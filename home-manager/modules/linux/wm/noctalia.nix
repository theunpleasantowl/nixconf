{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.noctalia = {
    enable = true;

    settings = {
      audio = {
        enable_sounds = false;
      };

      shell = {
        lang = "en";
        telemetry_enabled = false;
        clipboard_enabled = true;
        font_family = lib.mkForce "Lato";

        button_borders = true;
        input_borders = true;
        popup_borders = true;

        panel = {
          launcher_placement = "attached";
          open_near_click_clipboard = true;
          open_near_click_control_center = true;
          transparency_mode = "soft";
        };

        screenshot = {
          save_to_file = true;
          pipe_to_command = true;
          pipe_command = ''gradia "$NOCTALIA_SCREENSHOT_PATH"'';
          copy_to_clipboard = false;
        };

        mpris = {
          blacklist = [
            "ferdium"
            "firefox"
          ];
        };

        session = {
          actions = [
            {
              action = "lock";
              shortcut = "1";
            }
            {
              action = "logout";
              shortcut = "2";
            }
            {
              action = "lock_and_suspend";
              shortcut = "3";
            }
            {
              action = "command";
              label = "Hibernate";
              glyph = "snowflake";
              command = "systemctl hibernate";
              shortcut = "4";
            }
            {
              action = "reboot";
              shortcut = "5";
            }
            {
              action = "shutdown";
              shortcut = "6";
            }
          ];
        };
      };

      bar = {
        main = {
          position = "top";
          capsule = true;
          background_opacity = 0.8;
          concave_edge_corners = false;
          font_weight = 700;

          start = [
            "control-center"
            "network"
            "bluetooth"
            "weather"
            "caffeine"
            "media"
          ];

          center = [ "workspaces" ];

          end = [
            "sysmon-cpu"
            "sysmon-temp"
            "sysmon-ram"
            "sysmon-net"
            "sysmon-disk"
            "privacy"
            "tray"
            "volume"
            "battery"
            "clock"
          ];
        };
      };

      dock = {
        background_opacity = 0.7;
        magnification = false;
      };

      notification = {
        background_opacity = 0.5;
      };

      osd = {
        background_opacity = 0.5;
      };

      widget = {
        "control-center" = { };

        network = {
          capsule = true;
          show_vpn_label = true;
        };
        bluetooth = { };
        nightlight = { };

        "video-wallpaper" = {
          type = "noctalia/mpvpaper:mpvpaper";
        };

        workspaces = {
          style = "regular";
          show_labels = true;
          label_source = "id";
          hide_when_empty = false;
          labels_only_when_occupied = true;
        };

        tray = {
          pinned = [
            "Vesktop"
            "steam"
          ];
        };

        "sysmon-cpu" = {
          type = "sysmon";
          stat = "cpu_usage";
          visualization = "none";
          show_value = true;
        };

        "sysmon-temp" = {
          type = "sysmon";
          stat = "cpu_temp";
          visualization = "none";
          show_value = true;
        };

        "sysmon-ram" = {
          type = "sysmon";
          stat = "ram_used";
          visualization = "none";
          show_value = true;
        };

        "sysmon-net" = {
          type = "sysmon";
          stat = "net_rx";
          visualization = "none";
          show_value = true;
        };

        "sysmon-disk" = {
          type = "sysmon";
          stat = "disk_used_pct";
          visualization = "none";
          show_value = true;
          path = "/";
        };

        privacy = {
          hide_inactive = true;
        };

        volume = {
          show_label = true;
        };

        battery = {
          show_label = false;
        };

        clock = {
          format = "{:%-I:%M %p}";
          vertical_format = "{:%-I\n%M\n%p}";
        };
      };

      system = {
        monitor = {
          enabled = true;
        };
      };

      battery = {
        warning_threshold = 30;
      };

      location = {
        address = "Massachusetts, Boston";
      };

      weather = {
        unit = "imperial";
      };

      nightlight = {
        enabled = true;
      };

      wallpaper = {
        enabled = true;
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
        default.path = lib.mkForce "${config.home.homeDirectory}/Pictures/Wallpapers/Regular Wallpapers/1507396364426.jpg";
        transition = [ "fade" ];
        transition_duration = 500;
        edge_smoothness = 0;
        automation = {
          recursive = true;
        };
      };

      lockscreen = {
        enabled = true;
        grace_period_seconds = 2;
        lock_before_suspend = true;
        transition = [ "zoom" ];
      };

      plugin_settings."noctalia/mpvpaper" = {
        video_directory = "~/Pictures/Wallpapers/Video Wallpapers";
      };

      plugins = {
        enabled = [ "noctalia/mpvpaper" ];
        auto_update = "all";

        source = [
          {
            name = "local-plugins";
            kind = "path";
            location = "${./noctalia-plugins-v5}";
          }
          {
            name = "official-plugins";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins.git";
          }
        ];
      };
    };
  };

  home.packages = with pkgs; [
    cliphist
    mpvpaper
    gradia
  ];
}
