{...}: {
  home-manager.users.icarus = {pkgs, ...}: {
    home.packages = [pkgs.atool pkgs.httpie];
    programs.bash.enable = true;

    home.stateVersion = "25.05";
    home = {
      sessionVariables = {
        EDITOR = "nvim";
      };
      sessionPath = [
        "$HOME/.bin"
      ];
    };
  };
}
