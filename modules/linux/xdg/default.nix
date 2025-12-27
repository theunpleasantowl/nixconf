{pkgs, ...}: {
  imports = [
    ./portals.nix
    ./programs.nix
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
