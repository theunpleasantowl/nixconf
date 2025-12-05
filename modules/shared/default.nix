# home-manager/modules/linux/default.nix
{lib, pkgs, ...}: {
  imports = lib.optionals pkgs.stdenv.isLinux [
    ./applications
    ./wm
  ];
}
