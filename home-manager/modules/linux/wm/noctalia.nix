{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;

    settings = {
      shell = {
        lang = "en";
        telemetry_enabled = false;
        clipboard_enabled = true;
        font_family = "Lato";

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
      };

      bar = {
        main = {
          position = "top";
          capsule = true;
          background_opacity = 0.8;
          concave_edge_corners = true;
          font_weight = 700;

          start = [
            "control-center"
            "network"
            "bluetooth"
            "nightlight"
            "video-wallpaper"
          ];

          center = [ "workspaces" ];

          end = [
            "tray"
            "sysmon-cpu"
            "sysmon-temp"
            "sysmon-ram"
            "sysmon-net"
            "sysmon-disk"
            "privacy"
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

        network = { };
        bluetooth = { };
        nightlight = { };

        "video-wallpaper" = {
          type = "noctalia/mpvpaper:mpvpaper";
        };

        workspaces = {
          style = "regular";
          display = "id";
          hide_when_empty = false;
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
          display = "text";
        };

        "sysmon-temp" = {
          type = "sysmon";
          stat = "cpu_temp";
          display = "text";
        };

        "sysmon-ram" = {
          type = "sysmon";
          stat = "ram_used";
          display = "text";
        };

        "sysmon-net" = {
          type = "sysmon";
          stat = "net_rx";
          display = "text";
        };

        "sysmon-disk" = {
          type = "sysmon";
          stat = "disk_pct";
          path = "/";
          display = "text";
        };

        privacy = {
          hide_inactive = true;
        };

        volume = {
          show_label = true;
        };

        battery = {
          show_label = false;
          warning_threshold = 30;
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
        transition = [ "wipe" ];
        transition_duration = 500;
        edge_smoothness = 0;
        automation = {
          recursive = true;
        };
      };

      plugin_settings."noctalia/mpvpaper" = {
        video_directory = "~/Videos/Wallpapers";
      };

      plugins = {
        enabled = [
          "noctalia/mpvpaper"
          "noctalia/screen_recorder"
        ];

        source = [
          {
            name = "official-plugins";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins.git";
            auto_update = true;
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
