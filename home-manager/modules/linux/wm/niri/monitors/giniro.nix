{ osConfig, lib, ... }:
lib.mkIf (osConfig.networking.hostName == "giniro") {
  programs.niri.settings.outputs."eDP-1" = {
    scale = 2.0;
  };
}
