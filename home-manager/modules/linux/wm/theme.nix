{
  pkgs,
  lib,
  config,
  ...
}: {
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

  stylix.targets.firefox = lib.mkIf (config.stylix.enable or false) {
    enable = true;
    profileNames = ["default"];
  };
}
