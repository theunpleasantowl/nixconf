{ osConfig, lib, ... }:
lib.mkIf (osConfig.networking.hostName == "neptune") {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-3,preferred,auto,1"
      "DP-4,preferred,auto,1"
    ];

    workspace = [
      "1, monitor:DP-3, persistent:true, default:true"
      "3, monitor:DP-3, persistent:true"
      "5, monitor:DP-3, persistent:true"
      "7, monitor:DP-3, persistent:true"
      "9, monitor:DP-3, persistent:true"

      "2, monitor:DP-4, persistent:true, default:true"
      "4, monitor:DP-4, persistent:true"
      "6, monitor:DP-4, persistent:true"
      "8, monitor:DP-4, persistent:true"
      "10, monitor:DP-4, persistent:true"
    ];
  };
  programs.noctalia-shell.settings.bar.position = lib.mkForce "top";
}
