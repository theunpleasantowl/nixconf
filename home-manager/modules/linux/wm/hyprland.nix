{
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprexpo
      inputs.hyprland-virtual-desktops.packages.${pkgs.system}.virtual-desktops
    ];

    settings = {
      "$mainMod" = "SUPER";

      # ==== BINDS ====
      bind = [
        "$mainMod, M, fullscreen, 1"
        "$mainMod, F, fullscreen, 0"

        "$mainMod, G, exec, ~/.config/hypr/scripts/gaps.sh tog"
        "$mainMod, MINUS, exec, ~/.config/hypr/scripts/gaps.sh dec"
        "$mainMod, EQUAL, exec, ~/.config/hypr/scripts/gaps.sh inc"

        "$mainMod, C, killactive,"
        "$mainMod, E, exec, nautilus"
        "$mainMod SHIFT, F, togglefloating,"
        "ALT, SPACE, exec, wofi --show drun"
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

        # Volume/media
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMicMute, exec, pamixer --default-source -m"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        # Brightness
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"

        # Utilities
        "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        "$mainMod CONTROL, L, exec, swaylock -f -c 000000"
        "CONTROLALT, DELETE, exec, wleave -b 2 -c 0 -r 0 -L 930 -R 930 -T 300 -B 300 --protocol layer-shell"
        ", PRINT, exec, grimblast --freeze copysave area"
        "$mainMod Shift, C, exec, hyprpicker -a"

        # Notification center toggle
        "$mainMod, N, exec, swaync-client -t -sw"

        # Applications
        "$mainMod, Q, exec, wezterm"
        "$mainMod, Y, exec, wezterm start -- yazi"

        # Plugin - Hyprspace
        "$mainMod, S, hyprexpo:expo, toggle"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # ==== AUTOSTART ====
      exec-once = [
        "gsettings set org.gnome.desktop.interface color-scheme prefer-dark"
        "~/.bin/set_paper"
        "wlsunset -l 42.3 -L 71.0"
        "/usr/lib/polkit-kde-authentication-agent-1"
        "fcitx5"
        "hypridle"
        "waybar"
        "swaync"
        "blueman-applet"
        "nm-applet --indicator"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
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
          #color = "rgba(1a1a1aee)";
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

      gesture = [
        "3, horizontal, workspace"
      ];
    };
  };

  # Waybar configuration
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
          "battery"
          "custom/notification"
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
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        cpu = {
          format = " {usage}%";
          tooltip = false;
        };

        memory = {
          format = " {}%";
        };

        battery = {
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
        };

        network = {
          format-wifi = " {essid}";
          format-ethernet = " {ipaddr}";
          format-linked = " {ifname}";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
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
      #network,
      #pulseaudio,
      #tray,
      #custom-notification {
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
      }

      #custom-notification {
        font-size: 16px;
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
        font-family: "FiraCode Nerd Font", monospace;
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

  home.packages = with pkgs; [
    # Required for waybar
    playerctl
    pamixer
    pavucontrol

    # Notification utilities
    libnotify

    # For clipboard history
    cliphist
    wl-clipboard
  ];

  home.file = {
    # === gaps.sh ===
    ".config/hypr/scripts/gaps.sh".text = ''
      #!/bin/sh

      PATH_DECOR="$HOME/.config/hypr/hyprland.conf"
      INTERVAL_IN=2
      INTERVAL_OUT=8

      _get_gaps () {
        gap_in_current=$(hyprctl getoption general:gaps_in | cut -d' ' -f3)
        gap_out_current=$(hyprctl getoption general:gaps_out | cut -d' ' -f3)
      }

      _set_gaps () {
        hyprctl keyword general:gaps_in $gap_in_new
        hyprctl keyword general:gaps_out $gap_out_new
      }

      _get_gaps
      case "$1" in
        tog)
          if [ "$gap_in_current" -gt 0 ]; then
            gap_in_new=0
            gap_out_new=0
          else
            gap_in_new=$(grep gaps_in "$PATH_DECOR" | awk -F'[^0-9]+' '{ print $2 }')
            gap_out_new=$(grep gaps_out "$PATH_DECOR" | awk -F'[^0-9]+' '{ print $2 }')
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
        hyprctl keyword decoration:rounding 0
        gap_in_new=0
        gap_out_new=0
        _set_gaps
      else
        hyprctl keyword decoration:rounding $(grep rounding "$PATH_DECOR" | awk -F'[^0-9]+' '{ print $2 }')
      fi
    '';
    ".config/hypr/scripts/gaps.sh".executable = true;

    # === idle.sh ===
    ".config/hypr/scripts/idle.sh".text = ''
      #!/bin/sh
      swayidle -w \
        timeout 300 'swaylock -f -c 000000' \
        timeout 600 'hyprctl dispatch dpms off' \
        resume 'hyprctl dispatch dpms on' \
        timeout 900 'systemctl suspend' \
        before-sleep 'swaylock -f -c 000000' &
    '';
    ".config/hypr/scripts/idle.sh".executable = true;
  };
}
