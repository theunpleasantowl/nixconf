{
  inputs,
  system,
  lib,
  username ? "hibiki",
  isStandalone ? false,
  ...
}:
{
  home = {
    # Set username/homeDirectory for standalone home-manager
    # When used as NixOS module, we must not set these.
    username = lib.mkIf isStandalone username;
    homeDirectory = lib.mkIf isStandalone "/home/${username}";

    stateVersion = "26.05";

    sessionVariables = {
      EDITOR = "nvim";
    };

    sessionPath = [
      "$HOME/.bin"
    ];
  };

  wm.gnome.enable = true;
}
