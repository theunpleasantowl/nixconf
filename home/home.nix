{...}: {
  imports = [
    ./modules/shell/zsh.nix
    ./modules/utils
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    sessionVariables = {
      EDITOR = "nvim";
    };
    sessionPath = [
      "$HOME/.bin"
    ];
  };
}
