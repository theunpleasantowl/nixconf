{
  inputs,
  pkgs,
  ...
}: {
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    mako
    swww
    waybar
    wl-clipboard
    wofi
  ];
}
