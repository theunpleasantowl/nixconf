{pkgs, ...}: {
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
  };

  environment.systemPackages = let
    gnomeExtensions = with pkgs.gnomeExtensions; [
      clipboard-indicator
      dock-from-dash
    ];
  in
    with pkgs;
      [
        fractal
        komikku
        shortwave
        wike
        wordbook
      ]
      ++ gnomeExtensions;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-music
    epiphany
    totem
    geary
  ];
}
