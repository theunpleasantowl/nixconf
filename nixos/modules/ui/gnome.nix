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
      dock-from-dash
      kimpanel
      tophat
    ];
  in
    with pkgs;
      [
        ffmpegthumbnailer
        foliate
        ghostty
        gnome-epub-thumbnailer
        komikku
        shortwave
        wordbook
      ]
      ++ gnomeExtensions;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-console
    gnome-music
    gnome-music
    gnome-tour
    gnome-user-docs
    gnome-user-docs
    totem
  ];
}
