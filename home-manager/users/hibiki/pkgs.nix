{
  inputs,
  lib,
  pkgs,
  system,
  osConfig ? null,
  ...
}:
let
  # Use the system string only for conditional imports (evaluated before pkgs is finalised).
  isLinuxImport = builtins.match ".*-linux" system != null;
  isDarwinImport = builtins.match ".*-darwin" system != null;

  # Use stdenv for everything else (the modern, non-deprecated approach).
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isQemu = (osConfig.networking.hostName or "") == "qemu";

  # nixpkgs' ltrace 0.7.91 testsuite treats *any* compiler output as a build
  # failure (see ltrace_compile in testsuite/lib/ltrace.exp), so GCC 16's new
  # -Wvolatile warning in testsuite/ltrace.minor/demangle-lib.cpp breaks the
  # demangle fixtures and cascades into 15 spurious failures. Silence just that
  # warning for the test compiles. Drop this override once nixpkgs is fixed.
  ltraceFixed = pkgs.ltrace.overrideAttrs (_: {
    postPatch = ''
      sed -i 's|c++]|c++ additional_flags=-Wno-volatile]|g' \
        testsuite/ltrace.minor/demangle.exp
    '';
  });
in
{
  imports = [
    ../../modules/shared
  ]
  # Conditionally import platform-specific modules
  ++ lib.optionals isLinuxImport [
    ../../modules/linux
  ]
  ++ lib.optionals isDarwinImport [
    ../../modules/darwin
  ];

  nixpkgs.config = {
    allowUnfree = true;
    # TODO: Remove me
    permittedInsecurePackages = [
      "pnpm-10.29.2"
    ];
    ###
  };

  home.packages =
    with pkgs;
    [
      aria2
      browsh
      eza
      fastfetch
      fd
      ffmpeg
      git-extras
      glow
      jq
      lazygit
      nix-index
      stow
      sops
      songrec
      inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default
      yq-go
      yt-dlp
      weechat
      nethack
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      ethtool
      strace
      iftop
      iotop
      lm_sensors
      lsof
      ltraceFixed
      sysstat
      usbutils
      pciutils
    ];

  features = {
    media.enable = true;
  }
  // lib.optionalAttrs isLinux {
    ide.enable = true;
    gaming = {
      enable = true;
      retroarch = true;
      emulators = false;
      rpcs3 = false;
      extraGames = true;
    };
  };

  programs.home-manager.enable = true;
}
// lib.optionalAttrs isLinuxImport {
  wm.gnome.enable = true;
}
