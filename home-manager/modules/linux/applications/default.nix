{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./cloud.nix
    ./firefox.nix
    ./games.nix
    ./ide.nix
    ./image.nix
    ./video-editing.nix
    ./wezterm.nix
  ];
}
