{pkgs, ...}: let
  gnomeExtensions = with pkgs.gnomeExtensions; [
    clipboard-indicator
    dock-from-dash
    night-theme-switcher
  ];
  apps = with pkgs; [
    fractal
    komikku
    shortwave
    wike
    wordbook
  ];
in {
  # Enable the GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Add system packages
  environment.systemPackages = gnomeExtensions ++ apps;

  # Exclude unwanted GNOME applications
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-music
    epiphany
    totem
    geary # Email reader
  ];
}
