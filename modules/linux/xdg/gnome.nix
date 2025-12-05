{pkgs, ...}: {
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome = {
    enable = true;
  };

  environment.systemPackages = let
    gnomeExtensions = with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
      clipboard-indicator
      dash-to-dock
      kimpanel
      night-theme-switcher
      tiling-shell
      tophat
    ];
  in
    with pkgs;
      [
        ffmpegthumbnailer
        foliate
        ghostty
        gnome-epub-thumbnailer
        icoextract
        komikku
        mission-center
        refine
        shortwave
      ]
      ++ gnomeExtensions;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-console
    gnome-music
    gnome-system-monitor
    gnome-tour
    gnome-user-docs
    showtime
    totem
  ];
}
