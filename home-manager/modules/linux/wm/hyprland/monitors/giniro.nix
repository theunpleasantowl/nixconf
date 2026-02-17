{ osConfig, lib, ... }:
lib.mkIf (osConfig.networking.hostName == "giniro") {
  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1,preferred,auto,2"
  ];
}
