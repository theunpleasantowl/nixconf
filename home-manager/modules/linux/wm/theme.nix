{
  pkgs,
  lib,
  isStandalone ? false,
  ...
}:
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

    cursorTheme = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = lib.mkDefault 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = lib.mkDefault 1;
  };

  stylix = {
    enable = true;
    base16Scheme = lib.mkIf isStandalone "${pkgs.base16-schemes}/share/themes/katy.yaml";
    polarity = "dark";
    opacity = {
      applications = 1.0;
      desktop = 0.7;
      popups = 0.5;
      terminal = 1.0;
    };
  };
}
