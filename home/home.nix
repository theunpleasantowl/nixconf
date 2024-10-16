{...}: {
  imports = [
    ./modules/shell/zsh.nix
    ./modules/utils
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "hibiki";
  home.homeDirectory = "/home/hibiki";

  home.stateVersion = "24.05";
}
