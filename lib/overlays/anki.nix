# Fix anki's build against the current nixpkgs revision.
#
# Two separate issues are worked around here:
#
# 1. Offline Python build
#    nixpkgs' anki derivation resolves its Python build dependencies from a
#    vendored wheel directory (UV_FIND_LINKS) built from a fixed `pythonDeps`
#    list. That list includes `hatchling`, but not `hatchling`'s own runtime
#    dependency `tomlkit`, so the offline uv resolver fails with:
#
#      No solution found when resolving: `hatchling`
#      ... all versions of hatchling depend on tomlkit>=0.11.1 ...
#
#    Add tomlkit's wheel to the directory so the build can resolve it.
#
# 2. zstd-sys / pkg-config
#    rustPlatform.cargoSetupHook sets ZSTD_SYS_USE_PKG_CONFIG=1, which makes
#    zstd-sys look up libzstd with pkg-config instead of building it from
#    source. The derivation does not provide `pkg-config` or `zstd`, so add
#    them to the native build inputs.
final: prev: {
  anki = prev.anki.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      prev.pkg-config
      prev.zstd
    ];

    env = old.env // {
      UV_FIND_LINKS = prev.runCommand "anki-uv-wheels" { } ''
        mkdir -p $out
        ln -s ${prev.python3.pkgs.tomlkit.dist}/*.whl $out/
        ln -s ${old.env.UV_FIND_LINKS}/* $out/
      '';
    };
  });
}
