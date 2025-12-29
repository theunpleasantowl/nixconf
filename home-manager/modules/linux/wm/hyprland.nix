{
  pkgs,
  lib,
  ...
}: let
  hyprlandGaps = pkgs.writeShellScriptBin "hypr-gaps" ''
    #!/bin/sh

    PATH_DECOR="$HOME/.config/hypr/hyprland.conf"
    INTERVAL_IN=2
    INTERVAL_OUT=8

    _get_gaps () {
      gap_in_current=$(${pkgs.hyprland}/bin/hyprctl getoption general:gaps_in | cut -d' ' -f3)
      gap_out_current=$(${pkgs.hyprland}/bin/hyprctl getoption general:gaps_out | cut -d' ' -f3)
    }

    _set_gaps () {
      ${pkgs.hyprland}/bin/hyprctl keyword general:gaps_in $gap_in_new
      ${pkgs.hyprland}/bin/hyprctl keyword general:gaps_out $gap_out_new
    }

    _get_gaps
    case "$1" in
      tog)
        if [ "$gap_in_current" -gt 0 ]; then
          gap_in_new=0
          gap_out_new=0
        else
          gap_in_new=$(${pkgs.gnugrep}/bin/grep gaps_in "$PATH_DECOR" | ${pkgs.gawk}/bin/awk -F'[^0-9]+' '{ print $2 }')
          gap_out_new=$(${pkgs.gnugrep}/bin/grep gaps_out "$PATH_DECOR" | ${pkgs.gawk}/bin/awk -F'[^0-9]+' '{ print $2 }')
        fi
        ;;
      dec)
        if [ "$gap_in_current" -gt 0 ]; then
          gap_in_new=$(( gap_in_current - INTERVAL_IN ))
          gap_out_new=$(( gap_out_current - INTERVAL_OUT ))
        else
          exit 0
        fi
        ;;
      inc)
        gap_in_new=$(( gap_in_current + INTERVAL_IN ))
        gap_out_new=$(( gap_out_current + INTERVAL_OUT ))
        ;;
      *)
        exit 1
    esac

    _set_gaps

    # Assure Alignment
    _get_gaps
    if [ "$gap_in_current" -le 0 ] || [ "$gap_out_current" -le 0 ]; then
      ${pkgs.hyprland}/bin/hyprctl keyword decoration:rounding 0
      gap_in_new=0
      gap_out_new=0
      _set_gaps
    else
      ${pkgs.hyprland}/bin/hyprctl keyword decoration:rounding $(${pkgs.gnugrep}/bin/grep rounding "$PATH_DECOR" | ${pkgs.gawk}/bin/awk -F'[^0-9]+' '{ print $2 }')
    fi
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprexpo
    ];

    settings = {
      "$mainMod" = "SUPER";

      # ==== BINDS ====
      bind = [
        "$mainMod, M, fullscreen, 1"
        "$mainMod, F, fullscreen, 0"

        "$mainMod, G, exec, ${hyprlandGaps}/bin/hypr-gaps tog"
        "$mainMod, MINUS, exec, ${hyprlandGaps}/bin/hypr-gaps dec"
        "$mainMod, EQUAL, exec, ${hyprlandGaps}/bin/hypr-gaps inc"

        "$mainMod, C, killactive,"
        "$mainMod, E, exec, ${pkgs.nautilus}/bin/nautilus"
        "$mainMod SHIFT, F, togglefloating,"
        "ALT, SPACE, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "$mainMod, P, pseudo,"
        "$mainMod, T, togglesplit,"

        # Move focus (arrows + vim)
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Move window
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # Resize
        "$mainMod ALT, left, resizeactive, -10 0"
        "$mainMod ALT, right, resizeactive, 10 0"
        "$mainMod ALT, up, resizeactive, 0 -10"
        "$mainMod ALT, down, resizeactive, 0 10"
        "$mainMod ALT, h, resizeactive, -10 0"
        "$mainMod ALT, l, resizeactive, 10 0"
        "$mainMod ALT, k, resizeactive, 0 -10"
        "$mainMod ALT, j, resizeactive, 0 10"

        # Workspace navigation
        "$mainMod, 34, workspace, -1"
        "$mainMod, 35, workspace, +1"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move window to workspace
        "$mainMod SHIFT, 34, movetoworkspace, -1"
        "$mainMod SHIFT, 35, movetoworkspace, +1"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Scroll workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Volume/media controls - using wireplumber for better Wayland support
        ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"

        # Brightness
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5%-"

        # Utilities
        "$mainMod, V, exec, ${pkgs.cliphist}/bin/cliphist list | ${pkgs.wofi}/bin/wofi --dmenu | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy"

        # Lock screen
        "$mainMod CONTROL, L, exec, ${pkgs.hyprlock}/bin/hyprlock"

        # Power menu
        "CONTROLALT, DELETE, exec, ${pkgs.wlogout}/bin/wlogout"

        # Screenshots
        ", PRINT, exec, ${pkgs.grimblast}/bin/grimblast --freeze copysave area"
        "$mainMod, PRINT, exec, ${pkgs.grimblast}/bin/grimblast --freeze copysave screen"
        "$mainMod SHIFT, S, exec, ${pkgs.grimblast}/bin/grimblast --freeze copysave area"

        # Color picker
        "$mainMod SHIFT, C, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a"

        # Notification center toggle
        "$mainMod, N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"

        # Applications
        "$mainMod, Q, exec, ${pkgs.wezterm}/bin/wezterm"
        "$mainMod, Return, exec, ${pkgs.wezterm}/bin/wezterm"
        "$mainMod, Y, exec, ${pkgs.wezterm}/bin/wezterm start -- ${pkgs.yazi}/bin/yazi"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Lid switch bindings for laptops
      bindl = [
        ", switch:on:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock"
      ];

      # ==== AUTOSTART ====
      exec-once = [
        "~/.bin/set_paper"
        "${pkgs.wlsunset}/bin/wlsunset -l 42.3 -L 71.0"
        "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
        "${pkgs.fcitx5}/bin/fcitx5"
        "${pkgs.hypridle}/bin/hypridle"
        "${pkgs.waybar}/bin/waybar"
        "${pkgs.swaynotificationcenter}/bin/swaync"
        "${pkgs.blueman}/bin/blueman-applet"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store"
      ];

      monitor = ",preferred,auto,1";

      # ==== INPUT ====
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;
      };

      # ==== GENERAL ====
      general = {
        gaps_in = 4;
        gaps_out = 5;
        border_size = 1;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = lib.mkDefault "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # New gesture system
      gesture = [
        "3, horizontal, workspace"
      ];
    };
  };

  # Hyprlock configuration
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
      };

      background = lib.mkDefault [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = lib.mkDefault [
        {
          size = "300, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = lib.mkDefault "rgb(202, 211, 245)";
          inner_color = lib.mkDefault "rgb(91, 96, 120)";
          outer_color = lib.mkDefault "rgb(24, 25, 38)";
          outline_thickness = 3;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b><big> $(date +\"%H:%M\") </big></b>\"";
          color = lib.mkDefault "rgb(202, 211, 245)";
          font_size = 64;
          font_family = "FiraCode Nerd Font";
          position = "0, 16";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:18000000] echo \"<b> $(date +\"%A, %B %d\") </b>\"";
          color = lib.mkDefault "rgb(202, 211, 245)";
          font_size = 24;
          font_family = "FiraCode Nerd Font";
          position = "0, -16";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # Hypridle configuration for automatic locking
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  # Make hypridle Hyprland-only
  systemd.user.services.hypridle = {
    Unit = {
      ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
    };
  };

  # Waybar configuration with detailed system info
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = ["clock"];
        modules-right = [
          "tray"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "custom/notification"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
          sort-by-number = true;
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        clock = {
          format = "{:%H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
          };
        };

        cpu = {
          interval = 2;
          format = " {usage}%";
          tooltip = true;
          tooltip-format = "CPU: {usage}%\nFreq: {avg_frequency}GHz";
        };

        memory = {
          interval = 2;
          format = " {percentage}%";
          tooltip = true;
          tooltip-format = "RAM: {used:0.1f}GB / {total:0.1f}GB ({percentage}%)\nSwap: {swapUsed:0.1f}GB / {swapTotal:0.1f}GB";
        };

        temperature = {
          interval = 2;
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip = true;
        };

        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip-format = "{timeTo}\nPower: {power}W";
        };

        network = {
          interval = 2;
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ipaddr}/{cidr}";
          format-linked = " {ifname}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n⬆ {bandwidthUpBytes} ⬇ {bandwidthDownBytes}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\nFreq: {frequency}MHz\n⬆ {bandwidthUpBytes} ⬇ {bandwidthDownBytes}";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = " {icon}";
          format-muted = " {volume}%";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
          tooltip-format = "Volume: {volume}%";
        };

        tray = {
          icon-size = 21;
          spacing = 10;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        "custom/power" = {
          format = "";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "FiraCode Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 8px;
        color: #6c7086;
      }

      #workspaces button.active {
        color: #89b4fa;
      }

      #workspaces button.urgent {
        color: #f38ba8;
      }

      #workspaces button:hover {
        background: rgba(49, 50, 68, 0.5);
        color: #cdd6f4;
      }

      #window,
      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray,
      #custom-notification,
      #custom-power {
        padding: 0 10px;
        margin: 0 2px;
      }

      #battery.charging {
        color: #a6e3a1;
      }

      #battery.warning:not(.charging) {
        color: #fab387;
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
        animation: blink 1s ease-in-out infinite;
      }

      #cpu {
        color: #89dceb;
      }

      #memory {
        color: #cba6f7;
      }

      #temperature {
        color: #f9e2af;
      }

      #temperature.critical {
        color: #f38ba8;
      }

      #network {
        color: #94e2d5;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #custom-notification {
        font-size: 16px;
      }

      #custom-power {
        color: #f38ba8;
        font-size: 16px;
      }

      #custom-power:hover {
        background: rgba(243, 139, 168, 0.2);
      }

      @keyframes blink {
        to {
          color: #1e1e2e;
        }
      }
    '';
  };

  # SwayNC notification center configuration
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 600;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "title"
        "dnd"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };
    };

    style = ''
      * {
        font-family = "FiraCode Nerd Font", monospace;
        font-size: 13px;
      }

      .notification-row {
        outline: none;
        margin: 5px;
      }

      .notification {
        background: rgba(30, 30, 46, 0.95);
        border-radius: 10px;
        margin: 5px;
        padding: 10px;
        border: 1px solid rgba(137, 180, 250, 0.3);
      }

      .notification-content {
        margin: 5px;
      }

      .summary {
        color: #cdd6f4;
        font-size: 14px;
        font-weight: bold;
      }

      .body {
        color: #bac2de;
        margin-top: 5px;
      }

      .control-center {
        background: rgba(30, 30, 46, 0.95);
        border-radius: 10px;
        margin: 10px;
        border: 1px solid rgba(137, 180, 250, 0.3);
      }

      .control-center-list {
        background: transparent;
      }

      .widget-title {
        color: #cdd6f4;
        font-size: 16px;
        font-weight: bold;
        margin: 10px;
      }

      .widget-dnd {
        margin: 10px;
        padding: 10px;
        background: rgba(49, 50, 68, 0.5);
        border-radius: 5px;
      }

      .widget-dnd > switch {
        background: rgba(137, 180, 250, 0.3);
        border-radius: 12px;
      }

      .widget-dnd > switch:checked {
        background: #89b4fa;
      }
    '';
  };
  systemd.user.services.swaync = {
    Unit = {
      ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
    };
  };

  # Wlogout power menu
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];

    style = ''
      * {
        background-image: none;
        box-shadow: none;
      }

      window {
        background-color: rgba(30, 30, 46, 0.9);
      }

      button {
        color: #cdd6f4;
        background-color: rgba(49, 50, 68, 0.8);
        border-radius: 10px;
        border: 2px solid #89b4fa;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        margin: 20px;
      }

      button:focus, button:active, button:hover {
        background-color: rgba(137, 180, 250, 0.3);
        outline-style: none;
      }

      #lock {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #reboot {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }
    '';
  };

  home.packages = with pkgs; [
    libnotify
    pavucontrol
  ];
}
