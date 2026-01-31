{
  pkgs,
  lib,
  ...
}:
let
  pluginBinds = {
    hyprexpo = [
      "$mainMod, TAB, hyprexpo:expo, toggle"
      "$mainMod SHIFT, TAB, hyprexpo:expo, select"
    ];
  };

  enabledPluginBinds = lib.flatten (lib.attrValues pluginBinds);
  hyprGaps = import ./scripts/hyprlandGaps.nix { inherit lib pkgs; };
in
{
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

        "$mainMod, G, exec, ${lib.getExe hyprGaps} tog"
        "$mainMod, MINUS, exec, ${lib.getExe hyprGaps}  dec"
        "$mainMod, EQUAL, exec, ${lib.getExe hyprGaps} inc"

        "$mainMod, C, killactive,"
        "$mainMod, E, exec, ${lib.getExe pkgs.nautilus}"
        "$mainMod SHIFT, F, togglefloating,"
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

        # Core Noctalia binds
        "ALT, SPACE, exec, noctalia-shell ipc call launcher toggle"
        "$mainMod, S, exec, noctalia-shell ipc call controlCenter toggle"
        "$mainMod, D, exec, noctalia-shell ipc call calendar toggle"
        "$mainMod, comma, exec, noctalia-shell ipc call settings toggle"
        "$mainMod SHIFT, V, exec, noctalia-shell ipc call launcher clipboard"
        "$mainMod, period, exec, noctalia-shell ipc call launcher emoji"

        # Volume/media controls - using wireplumber for better Wayland support
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
        ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
        ", XF86AudioPause, exec, ${lib.getExe pkgs.playerctl} play-pause"
        ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
        ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"

        # Brightness controls
        ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
        ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"

        # Lock screen
        "CONTROLALT, Q, exec, noctalia-shell ipc call lockScreen lock"

        # Power menu
        "CONTROLALT, DELETE, exec, noctalia-shell ipc call sessionMenu toggle"
        #"CONTROLALT, DELETE, exec, ${lib.getExe pkgs.wlogout}"

        # Screenshots
        ", PRINT, exec, ${lib.getExe pkgs.hyprshot} --output ~/Screenshots/ --mode window"
        "$mainMod, PRINT, exec, ${lib.getExe pkgs.hyprshot} --output ~/Screenshots/ --freeze --mode output"
        "$mainMod SHIFT, S, exec, ${lib.getExe pkgs.hyprshot} --output ~/Screenshots/ --freeze --mode region"
        "$mainMod SHIFT, T, exec, ${lib.getExe pkgs.hyprshot} --mode region --raw | ${lib.getExe pkgs.tesseract} - - -l eng | ${pkgs.wl-clipboard}/bin/wl-copy"

        # Color picker
        "$mainMod SHIFT, C, exec, ${lib.getExe pkgs.hyprpicker} --autocopy"

        # Notification center toggle
        "$mainMod, N, exec, noctalia-shell ipc call notifications toggleHistory"
        #"$mainMod, N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"

        # Applications
        "$mainMod, Q, exec, ${lib.getExe pkgs.wezterm}"
        "$mainMod, Return, exec, ${lib.getExe pkgs.wezterm}"
        "$mainMod, Y, exec, ${lib.getExe pkgs.wezterm} start -- ${lib.getExe pkgs.yazi}"
        "$mainMod, U, exec, ${lib.getExe pkgs.wezterm} start -- ${lib.getExe pkgs.youtube-tui}"
      ]
      ++ enabledPluginBinds;

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      # Lid switch bindings for laptops
      bindl = [
        ", switch:on:Lid Switch, exec, noctalia-shell ipc call sessionMenu lockAndSuspend"
        #", switch:on:Lid Switch, exec, ${lib.getExe pkgs.hyprlock}"
      ];

      # ==== AUTOSTART ====
      exec-once = [
        "${lib.getExe pkgs.fcitx5} -d -r"
        "${lib.getExe pkgs.keepassxc}"

        # I prefer to allow QuickShell to provide this functionality
        #"${lib.getExe pkgs.blueman}"
        #"${lib.getExe pkgs.hypridle}"
        #"${lib.getExe pkgs.swaynotificationcenter}"
        #"${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        #"${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store"
        #"${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store"
        #"${pkgs.wlsunset}/bin/wlsunset -l 42.3 -L 71.0"
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

      gesture = [
        "3, horizontal, workspace"
      ];

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 3;
      };
    };
  };

  services = {
    gnome-keyring.enable = true;
    hyprpolkitagent.enable = true;
    nextcloud-client.enable = true;
  };

  #  home.packages = with pkgs; [
  #  libnotify
  #  pavucontrol
  #];

  #  services.gnome-keyring = {
  #    enable = true;
  #    components = [
  #      "pkcs11"
  #      "secrets"
  #      "ssh"
  #    ];
  #  };
}
