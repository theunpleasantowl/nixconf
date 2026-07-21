{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.desktop;
  hasGnome = cfg.gnome.enable or false;
  hasHyprland = cfg.hyprland.enable or false;
  hasAny = cfg.anyEnabled;
in
{
  config = lib.mkIf hasAny {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;

      extraPortals =
        lib.optional hasGnome pkgs.xdg-desktop-portal-gnome
        ++ lib.optional hasHyprland pkgs.xdg-desktop-portal-hyprland;
    };
    security.polkit.enable = true;
  };
}
