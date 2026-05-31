{
  lib,
  pkgs,
  username ? "hibiki",
  ...
}:
let
  homePrefix = if pkgs.stdenv.isDarwin then "/Users" else "/home";
in
{
  home = {
    username = lib.mkDefault username;
    homeDirectory = lib.mkDefault "${homePrefix}/${username}";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
    sessionPath = [
      "$HOME/.bin"
    ];
  };
}
