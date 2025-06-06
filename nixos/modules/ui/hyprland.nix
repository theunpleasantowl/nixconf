{pkgs, ...}: {
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    waybar
    mako
    wezterm
    wofi
    wl-clipboard
  ];
}
