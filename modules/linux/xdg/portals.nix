{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      gnome.default = [
        "gnome"
      ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };
  };
}
