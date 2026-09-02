{ osConfig ? null, lib, ... }:
lib.mkMerge [
  (lib.mkIf ((osConfig.networking.hostName or null) == "giniro") {
    wayland.windowManager.hyprland.settings = {
      monitor = [
        {
          output = "eDP-1";
          mode = "preferred";
          position = "auto";
          scale = 2;
        }
      ];

      config.decoration.blur = {
        enabled = lib.mkForce false;
      };
    };

  })
]
