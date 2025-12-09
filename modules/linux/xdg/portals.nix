{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
    config = {
      # Default fallback
      common = {
        default = [
          "gtk"
        ];
      };

      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
      };

      gnome = {
        default = [
          "gnome"
          "gtk"
        ];
      };
    };
  };
}
