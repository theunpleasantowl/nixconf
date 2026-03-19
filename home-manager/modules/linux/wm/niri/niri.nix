{
  pkgs,
  lib,
  ...
}:
let
  screenshotDir = "~/Screenshots";
in
{
  programs.niri.settings = {
    input = {
      keyboard.xkb.layout = "us";
      focus-follows-mouse.enable = true;
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
    };

    layout = {
      gaps = 5;
      center-focused-column = "never";

      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];

      default-column-width = {
        proportion = 1.0 / 2.0;
      };

      focus-ring = {
        enable = true;
        width = 1;
        active.color = lib.mkDefault "#7fc8ff";
        inactive.color = lib.mkDefault "#505050";
      };

      border = {
        enable = false;
      };

      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
        color = lib.mkDefault "#00000070";
      };
    };

    animations = {
      workspace-switch.kind = {
        spring = {
          damping-ratio = 1.0;
          stiffness = 1000;
          epsilon = 0.0001;
        };
      };
      horizontal-view-movement.kind = {
        spring = {
          damping-ratio = 1.0;
          stiffness = 800;
          epsilon = 0.0001;
        };
      };
      window-open.kind = {
        easing = {
          duration-ms = 150;
          curve = "ease-out-expo";
        };
      };
      window-close.kind = {
        easing = {
          duration-ms = 150;
          curve = "ease-out-quad";
        };
      };
      config-notification-open-close.kind = {
        spring = {
          damping-ratio = 0.6;
          stiffness = 1000;
          epsilon = 0.001;
        };
      };
    };

    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
    screenshot-path = "${screenshotDir}/Screenshot from %Y-%m-%d %H-%M-%S.png";

    environment = {
      NIXOS_OZONE_WL = "1";
      DISPLAY = ":0";
    };

    spawn-at-startup = [
      { argv = [ "${lib.getExe pkgs.keepassxc}" ]; }
      #{ argv = [ "${pkgs.wl-clipboard}/bin/wl-paste" "--type" "image" "--watch" "${pkgs.cliphist}/bin/cliphist" "store" ]; }
      #{ argv = [ "${pkgs.wl-clipboard}/bin/wl-paste" "--type" "text" "--watch" "${pkgs.cliphist}/bin/cliphist" "store" ]; }
    ];

    window-rules = [
      {
        geometry-corner-radius =
          let
            r = 10.0;
          in
          {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
        clip-to-geometry = true;
      }
    ];

    binds = {
      "Mod+F" = {
        action.fullscreen-window = [ ];
      };
      "Mod+M" = {
        action.maximize-column = [ ];
      };
      "Mod+C" = {
        action.close-window = [ ];
      };
      "Mod+Shift+F" = {
        action.toggle-window-floating = [ ];
      };

      "Mod+T" = {
        action.toggle-column-tabbed-display = [ ];
      };

      "Mod+R" = {
        action.switch-preset-column-width = [ ];
      };
      "Mod+Shift+R" = {
        action.switch-preset-window-height = [ ];
      };

      "Mod+Left" = {
        action.focus-column-left = [ ];
      };
      "Mod+Right" = {
        action.focus-column-right = [ ];
      };
      "Mod+Up" = {
        action.focus-window-or-workspace-up = [ ];
      };
      "Mod+Down" = {
        action.focus-window-or-workspace-down = [ ];
      };
      "Mod+H" = {
        action.focus-column-left = [ ];
      };
      "Mod+L" = {
        action.focus-column-right = [ ];
      };
      "Mod+K" = {
        action.focus-window-or-workspace-up = [ ];
      };
      "Mod+J" = {
        action.focus-window-or-workspace-down = [ ];
      };

      "Mod+Shift+Left" = {
        action.move-column-left = [ ];
      };
      "Mod+Shift+Right" = {
        action.move-column-right = [ ];
      };
      "Mod+Shift+Up" = {
        action.move-window-up-or-to-workspace-up = [ ];
      };
      "Mod+Shift+Down" = {
        action.move-window-down-or-to-workspace-down = [ ];
      };
      "Mod+Shift+H" = {
        action.move-column-left = [ ];
      };
      "Mod+Shift+L" = {
        action.move-column-right = [ ];
      };
      "Mod+Shift+K" = {
        action.move-window-up-or-to-workspace-up = [ ];
      };
      "Mod+Shift+J" = {
        action.move-window-down-or-to-workspace-down = [ ];
      };

      "Mod+Ctrl+BracketLeft" = {
        action.consume-or-expel-window-left = [ ];
      };
      "Mod+Ctrl+BracketRight" = {
        action.consume-or-expel-window-right = [ ];
      };

      "Mod+Alt+Left" = {
        action.set-column-width = "-10%";
      };
      "Mod+Alt+Right" = {
        action.set-column-width = "+10%";
      };
      "Mod+Alt+Up" = {
        action.set-window-height = "-10%";
      };
      "Mod+Alt+Down" = {
        action.set-window-height = "+10%";
      };
      "Mod+Alt+H" = {
        action.set-column-width = "-10%";
      };
      "Mod+Alt+L" = {
        action.set-column-width = "+10%";
      };
      "Mod+Alt+K" = {
        action.set-window-height = "-10%";
      };
      "Mod+Alt+J" = {
        action.set-window-height = "+10%";
      };

      "Mod+BracketLeft" = {
        action.focus-workspace-up = [ ];
      };
      "Mod+BracketRight" = {
        action.focus-workspace-down = [ ];
      };
      "Mod+1" = {
        action.focus-workspace = 1;
      };
      "Mod+2" = {
        action.focus-workspace = 2;
      };
      "Mod+3" = {
        action.focus-workspace = 3;
      };
      "Mod+4" = {
        action.focus-workspace = 4;
      };
      "Mod+5" = {
        action.focus-workspace = 5;
      };
      "Mod+6" = {
        action.focus-workspace = 6;
      };
      "Mod+7" = {
        action.focus-workspace = 7;
      };
      "Mod+8" = {
        action.focus-workspace = 8;
      };
      "Mod+9" = {
        action.focus-workspace = 9;
      };
      "Mod+0" = {
        action.focus-workspace = 10;
      };

      "Mod+Shift+1" = {
        action.move-window-to-workspace = 1;
      };
      "Mod+Shift+2" = {
        action.move-window-to-workspace = 2;
      };
      "Mod+Shift+3" = {
        action.move-window-to-workspace = 3;
      };
      "Mod+Shift+4" = {
        action.move-window-to-workspace = 4;
      };
      "Mod+Shift+5" = {
        action.move-window-to-workspace = 5;
      };
      "Mod+Shift+6" = {
        action.move-window-to-workspace = 6;
      };
      "Mod+Shift+7" = {
        action.move-window-to-workspace = 7;
      };
      "Mod+Shift+8" = {
        action.move-window-to-workspace = 8;
      };
      "Mod+Shift+9" = {
        action.move-window-to-workspace = 9;
      };
      "Mod+Shift+0" = {
        action.move-window-to-workspace = 10;
      };

      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action.focus-workspace-down = [ ];
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action.focus-workspace-up = [ ];
      };
      "Mod+WheelScrollRight" = {
        action.focus-column-right = [ ];
      };
      "Mod+WheelScrollLeft" = {
        action.focus-column-left = [ ];
      };

      "Mod+Shift+BracketLeft" = {
        action.move-window-to-workspace-up = [ ];
      };
      "Mod+Shift+BracketRight" = {
        action.move-window-to-workspace-down = [ ];
      };

      "Mod+Ctrl+Left" = {
        action.focus-monitor-left = [ ];
      };
      "Mod+Ctrl+Right" = {
        action.focus-monitor-right = [ ];
      };
      "Mod+Ctrl+H" = {
        action.focus-monitor-left = [ ];
      };
      "Mod+Ctrl+L" = {
        action.focus-monitor-right = [ ];
      };
      "Mod+Ctrl+Shift+Left" = {
        action.move-window-to-monitor-left = [ ];
      };
      "Mod+Ctrl+Shift+Right" = {
        action.move-window-to-monitor-right = [ ];
      };
      "Mod+Ctrl+Shift+H" = {
        action.move-window-to-monitor-left = [ ];
      };
      "Mod+Ctrl+Shift+L" = {
        action.move-window-to-monitor-right = [ ];
      };

      "Alt+Space" = {
        repeat = false;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "launcher"
          "toggle"
        ];
      };
      "Mod+S" = {
        repeat = false;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "controlCenter"
          "toggle"
        ];
      };
      "Mod+D" = {
        repeat = false;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "calendar"
          "toggle"
        ];
      };
      "Mod+Comma" = {
        repeat = false;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "settings"
          "toggle"
        ];
      };
      "Mod+Shift+V" = {
        repeat = false;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "launcher"
          "clipboard"
        ];
      };
      "Mod+Period" = {
        repeat = false;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "launcher"
          "emoji"
        ];
      };

      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "volume"
          "increase"
        ];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "volume"
          "decrease"
        ];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "volume"
          "muteOutput"
        ];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = [
          "${pkgs.wireplumber}/bin/wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SOURCE@"
          "toggle"
        ];
      };
      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = [
          "${lib.getExe pkgs.playerctl}"
          "play-pause"
        ];
      };
      "XF86AudioPause" = {
        allow-when-locked = true;
        action.spawn = [
          "${lib.getExe pkgs.playerctl}"
          "play-pause"
        ];
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = [
          "${lib.getExe pkgs.playerctl}"
          "next"
        ];
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = [
          "${lib.getExe pkgs.playerctl}"
          "previous"
        ];
      };

      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "brightness"
          "increase"
        ];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "brightness"
          "decrease"
        ];
      };

      "Ctrl+Alt+Q" = {
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "lockScreen"
          "lock"
        ];
      };

      "Ctrl+Alt+Delete" = {
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "sessionMenu"
          "toggle"
        ];
      };

      "Print" = {
        action.screenshot = [ ];
      };
      "Mod+Print" = {
        action.screenshot-screen = [ ];
      };
      "Mod+Shift+S" = {
        action.screenshot = [ ];
      };
      "Mod+Shift+T" = {
        action.spawn-sh = "${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\" - | ${lib.getExe pkgs.tesseract} - - -l eng | ${pkgs.wl-clipboard}/bin/wl-copy";
      };

      "Mod+Shift+C" = {
        repeat = false;
        action.spawn = [
          "${lib.getExe pkgs.hyprpicker}"
          "--autocopy"
        ];
      };

      "Mod+N" = {
        repeat = false;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "notifications"
          "toggleHistory"
        ];
      };

      "Mod+W" = {
        repeat = false;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "wallpaper"
          "toggle"
        ];
      };
      "Mod+Shift+W" = {
        repeat = false;
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "plugin:videowallpaper"
          "openPanel"
        ];
      };

      "Mod+Q" = {
        repeat = false;
        action.spawn = [ "${lib.getExe pkgs.wezterm}" ];
      };
      "Mod+Return" = {
        repeat = false;
        action.spawn = [ "${lib.getExe pkgs.wezterm}" ];
      };
      "Mod+E" = {
        repeat = false;
        action.spawn = [ "${lib.getExe pkgs.nautilus}" ];
      };
      "Mod+Y" = {
        repeat = false;
        action.spawn = [
          "${lib.getExe pkgs.wezterm}"
          "start"
          "--"
          "${lib.getExe pkgs.yazi}"
        ];
      };
      "Mod+U" = {
        repeat = false;
        action.spawn = [
          "${lib.getExe pkgs.wezterm}"
          "start"
          "--"
          "${lib.getExe pkgs.youtube-tui}"
        ];
      };

      "Mod+Shift+E" = {
        action.quit = {
          skip-confirmation = true;
        };
      };

      "Mod+P" = {
        action.toggle-overview = [ ];
      };
    };

    switch-events = {
      lid-close = {
        action.spawn = [
          "noctalia-shell"
          "ipc"
          "call"
          "sessionMenu"
          "lockAndSuspend"
        ];
      };
    };
  };

  services = {
    gnome-keyring.enable = true;
    nextcloud-client.enable = true;
  };
}
