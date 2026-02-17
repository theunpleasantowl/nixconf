{ osConfig, lib, ... }:
lib.mkIf (osConfig.networking.hostName == "neptune") {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-3,preferred,auto,1"
      "DP-4,preferred,auto,1"
    ];

    workspace = [
      "1, monitor:DP-3, default:true"
      "3, monitor:DP-3"
      "5, monitor:DP-3"
      "7, monitor:DP-3"
      "9, monitor:DP-3"

      "2, monitor:DP-4, default:true"
      "4, monitor:DP-4"
      "6, monitor:DP-4"
      "8, monitor:DP-4"
      "10, monitor:DP-4"
    ];
  };
}
