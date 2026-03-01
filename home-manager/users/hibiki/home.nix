{
  lib,
  config,
  ...
}:
let
  username = config._module.args.username or "hibiki";
in
{
  home = {
    username = lib.mkDefault username;
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = "26.05";
    sessionVariables = {
      EDITOR = "nvim";
    };
    sessionPath = [
      "$HOME/.bin"
    ];
  };
}
