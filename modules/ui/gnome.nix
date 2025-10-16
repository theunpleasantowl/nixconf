{pkgs, ...}: {
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome = {
    enable = true;
  };
  systemd.services.gnome-remote-desktop = {
    wantedBy = ["graphical.target"];
  };

  environment.systemPackages = let
    gnomeExtensions = with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
      clipboard-indicator
      dock-from-dash
      kimpanel
      night-theme-switcher
      tiling-shell
      tophat
    ];
  in
    with pkgs;
      [
        refine
        ffmpegthumbnailer
        foliate
        ghostty
        gnome-epub-thumbnailer
        komikku
        shortwave
        mission-center
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
    totem
  ];
}
