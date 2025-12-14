{
  inputs,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  security.polkit.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland:
  services.udisks2.enable = true; # Disk Management

  environment.systemPackages = with pkgs; [
    swww
    waybar
    wl-clipboard
  ];
}
