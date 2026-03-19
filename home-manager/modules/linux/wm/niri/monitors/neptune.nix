{ osConfig, lib, ... }:
lib.mkIf (osConfig.networking.hostName == "neptune") {
  programs.niri.settings = {
    outputs."DP-3" = {
      scale = 1.0;
    };
    outputs."DP-4" = {
      scale = 1.0;
    };

    workspaces = {
      "01-ws1" = { name = "1"; open-on-output = "DP-3"; };
      "02-ws2" = { name = "2"; open-on-output = "DP-4"; };
      "03-ws3" = { name = "3"; open-on-output = "DP-3"; };
      "04-ws4" = { name = "4"; open-on-output = "DP-4"; };
      "05-ws5" = { name = "5"; open-on-output = "DP-3"; };
      "06-ws6" = { name = "6"; open-on-output = "DP-4"; };
      "07-ws7" = { name = "7"; open-on-output = "DP-3"; };
      "08-ws8" = { name = "8"; open-on-output = "DP-4"; };
      "09-ws9" = { name = "9"; open-on-output = "DP-3"; };
      "10-ws10" = { name = "10"; open-on-output = "DP-4"; };
    };
  };
  programs.noctalia-shell.settings.bar.position = lib.mkForce "top";
}
