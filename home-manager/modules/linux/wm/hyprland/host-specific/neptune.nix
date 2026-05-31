{ osConfig ? null, lib, ... }:
lib.mkIf ((osConfig.networking.hostName or null) == "neptune") {
  wayland.windowManager.hyprland.settings = {
    monitor = [
      {
        output = "DP-3";
        mode = "preferred";
        position = "auto";
        scale = 1;
      }
      {
        output = "DP-4";
        mode = "preferred";
        position = "auto";
        scale = 1;
      }
    ];

    workspace_rule = [
      {
        workspace = "1";
        monitor = "DP-3";
        persistent = true;
        default = true;
      }
      {
        workspace = "2";
        monitor = "DP-3";
        persistent = true;
      }
      {
        workspace = "3";
        monitor = "DP-3";
        persistent = true;
      }
      {
        workspace = "4";
        monitor = "DP-3";
        persistent = true;
      }
      {
        workspace = "5";
        monitor = "DP-3";
        persistent = true;
      }

      {
        workspace = "6";
        monitor = "DP-4";
        persistent = true;
        default = true;
      }
      {
        workspace = "7";
        monitor = "DP-4";
        persistent = true;
      }
      {
        workspace = "8";
        monitor = "DP-4";
        persistent = true;
      }
      {
        workspace = "9";
        monitor = "DP-4";
        persistent = true;
      }
      {
        workspace = "10";
        monitor = "DP-4";
        persistent = true;
      }
    ];

    config.general = {
      gaps_in = lib.mkForce 8;
      gaps_out = lib.mkForce 32;
      border_size = lib.mkForce 2;
    };
    config.decoration = {
      blur = {
        size = lib.mkForce 8;
        passes = lib.mkForce 3;
      };
      rounding = lib.mkForce 0;
    };
  };
  programs.noctalia-shell.settings.bar.position = lib.mkForce "top";
  programs.noctalia-shell.settings.bar.outerCorners = lib.mkForce "false";
}
