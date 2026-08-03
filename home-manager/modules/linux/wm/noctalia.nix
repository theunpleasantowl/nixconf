{
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
          display = "id";
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
          display = "text";
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

      lockscreen_widgets = {
        enabled = false;
        widget_order = [
          "lockscreen-login-box@DP-4"
          "lockscreen-login-box@DP-3"
        ];

        widget = {
          "lockscreen-login-box@DP-3" = {
            type = "login_box";
            output = "DP-3";
            cx = 1280.0;
            cy = 1321.0;
            box_width = 400.0;
            box_height = 70.0;
            rotation = 0.0;

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
            };
          };

          "lockscreen-login-box@DP-4" = {
            type = "login_box";
            output = "DP-4";
            cx = 1280.0;
            cy = 1321.0;
            box_width = 400.0;
            box_height = 70.0;
            rotation = 0.0;

            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
            };
          };
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
