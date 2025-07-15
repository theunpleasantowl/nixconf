{
  homeDirectory,
  stateVersion,
  username,
  ...
}: {
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
