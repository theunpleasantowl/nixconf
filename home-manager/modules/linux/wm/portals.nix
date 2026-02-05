# For some reason, when XDG Portals are configured at the system-level, they
# only start properly on the second login. I found from Reddit of all places
# that setting it in home-manager works reliably, but I don't know that it's
# properly documented anywhere.
# https://www.reddit.com/r/NixOS/comments/1lvt4ej/frustrating_every_xdgdesktopportal_backend_stays/
{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-hyprland
    ];
    config = {
      hyprland.default = [
        "hyprland"
        "gnome"
      ];
    };
  };
}
