{
  pkgs,
  lib,
  ...
}:
let
  cursorTheme = {
    name = "Nordzy-cursors";
    package = pkgs.nordzy-cursor-theme;
    size = 24;
  };
in
{
  gtk = {
    enable = true;
    theme = lib.mkDefault {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };

    inherit cursorTheme;

    gtk3.extraConfig.gtk-application-prefer-dark-theme = lib.mkDefault 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = lib.mkDefault 1;
  };

  home.pointerCursor = {
    inherit (cursorTheme) name package size;
    enable = true;
    gtk.enable = true;
    x11.enable = true;
  };

  xdg.dataFile."icons/${cursorTheme.name}".source =
    "${cursorTheme.package}/share/icons/${cursorTheme.name}";

  stylix = {
    enable = lib.mkDefault true;
    opacity = {
      applications = lib.mkDefault 1.0;
      desktop = lib.mkDefault 0.7;
      popups = lib.mkDefault 0.5;
      terminal = lib.mkDefault 1.0;
    };
  };
}
