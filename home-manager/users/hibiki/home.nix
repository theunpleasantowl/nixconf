{
  lib,
  pkgs,
  config,
  ...
}:
let
  username = config._module.args.username or "hibiki";
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
