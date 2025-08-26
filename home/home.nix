{...}: {
  home.username = "hibiki";
  home.homeDirectory = "/home/hibiki";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/.bin"
  ];

  imports = [
    ./pkgs.nix
  ];
}
