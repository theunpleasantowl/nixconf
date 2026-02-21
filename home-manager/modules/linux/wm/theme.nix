{
  pkgs,
  lib,
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
    enable = lib.mkDefault true;
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/katy.yaml";
    polarity = lib.mkDefault "dark";
    opacity = {
      applications = lib.mkDefault 1.0;
      desktop = lib.mkDefault 0.7;
      popups = lib.mkDefault 0.5;
      terminal = lib.mkDefault 1.0;
    };
  };
}
