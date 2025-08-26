{pkgs, ...}: {
  imports = with builtins;
    map
    (fn: ./${fn})
    (filter (fn: fn != "default.nix") (attrNames (readDir ./.)));

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
