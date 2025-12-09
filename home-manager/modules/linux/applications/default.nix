{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./cloud.nix
    ./games.nix
    ./ide.nix
    ./image.nix
    ./video-editing.nix
    ./wezterm.nix
  ];
}
