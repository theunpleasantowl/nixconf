{pkgs, ...}: {
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    fractal
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dock-from-dash
  ];
}
