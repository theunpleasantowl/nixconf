{pkgs, ...}: {
  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./programs.nix
    ./windowmaker.nix
  ];
  # Enable Mesa
  hardware.graphics = {
    enable = true;
  };
  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
  };
}
