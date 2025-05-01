{pkgs, ...}: {
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  environment.systemPackages = let
    gnomeExtensions = with pkgs.gnomeExtensions; [
      pop-shell
      blur-my-shell
      clipboard-indicator
      dock-from-dash
      kimpanel
    ];
  in
    with pkgs;
      [
        foliate
        fractal
        ghostty
        gnome-epub-thumbnailer
        komikku
        shortwave
        wike
      ]
      ++ gnomeExtensions;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-console
    gnome-music
    gnome-tour
    gnome-user-docs
    totem
  ];
}
