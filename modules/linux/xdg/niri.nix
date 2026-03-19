{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.desktop.niri;
in
{
  options.features.linux.desktop.niri = {
    enable = lib.mkEnableOption "niri scrollable tiling Wayland compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.niri = {
      enable = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    services.udisks2.enable = true;

    # XDG portal for niri (use GNOME portal as fallback)
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
    };
  };
}
