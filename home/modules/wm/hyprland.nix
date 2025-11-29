{
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    # set the flake package
    plugins = [
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
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

        # Mouse binds
        "bindm = $mainMod, mouse:272, movewindow"
        "bindm = $mainMod, mouse:273, resizewindow"

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

        # Applications
        "$mainMod, Q, exec, wezterm"
        "$mainMod, Y, exec, wezterm start -- yazi"
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
        touchpad.natural_scroll = true;
        sensitivity = 0;
      };

      # ==== GENERAL ====
      general = {
        gaps_in = 4;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
      };

      animations = {
        enabled = true;
        bezier = ["myBezier, 0.05, 0.9, 0.1, 1.05"];
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

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };
    };
  };

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
