{
  homeDirectory,
  stateVersion,
  username,
  ...
}: {
  imports = [
    ./modules/shell/zsh.nix
    ./modules/utils
  ];

  home = {
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;
    username = username;

    sessionVariables = {
      EDITOR = "nvim";
    };
    sessionPath = [
      "$HOME/.bin"
    ];
  };
}
