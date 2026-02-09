{ ... }:
{
  imports =
    with builtins;
    map (fn: ./${fn}) (
      filter (fn: fn != "default.nix" && fn != null && match ".*\\.nix$" fn != null) (
        attrNames (readDir ./.)
      )
    );
}
