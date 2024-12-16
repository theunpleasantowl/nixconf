{pkgs, ...}: {
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    fractal
    komikku
    shortwave
    wike
    wordbook

    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dock-from-dash
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-music
    epiphany
    totem
    geary # email reader
  ];
}
