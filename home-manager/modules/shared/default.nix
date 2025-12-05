# home-manager/modules/shared/default.nix
{...}: {
  imports = [
    ./applications
    ./misc
    ./shell
    ./utils
  ];
}
