{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        pomodoro = {
          enabled = true;
        };
        privacy-indicator = {
          enabled = true;
        };
        video-wallpaper = {
          enabled = true;
        };
      };
    };
    settings = {
      bar = {
        density = "compact";
        position = "right";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
            {
              id = "WiFi";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "NightLight";
            }
            {
              id = "plugin:video-wallpaper";
            }
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "index";
              showApplications = true;
            }
          ];
          right = [
            {
              id = "Tray";
              pinned = [
                "Vesktop"
                "steam"
              ];
            }
            {
              id = "SystemMonitor";
              compactMode = true;
              showCpuUsage = true;
              showCpuTemp = true;
              showLoadAverage = false;
              showMemoryUsage = true;
              showMemoryAsPercent = true;
              showNetworkStats = true;
            }
            { id = "plugin:privacy-indicator"; }
            { id = "plugin:pomodoro"; }
            {
              id = "Volume";
              alwaysVisible = true;
              showPercentage = true;
              middleClickCommand = "${lib.getExe pkgs.lxqt.pavucontrol-qt}";
            }
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "hh:mm AP";
              formatVertical = "hh mm AP";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      colorSchemes.predefinedScheme = "Monochrome";
      general = {
        showChangelogOnStartup = false;
        telemetryEnabled = false;
      };
      ui = {
        "boxBorderEnabled" = true;
      };
      audio = {
        visualizerType = "mirrored";
      };
      location = {
        monthBeforeDay = true;
        name = "Massachusetts, Boston";
        useFahrenheit = true;
        use12hourFormat = true;
        analogClockInCalendar = true;
      };
      nightLight = {
        enabled = true;
        #forced = false;
        #autoSchedule = true;
        #nightTemp = "4000";
        #dayTemp = "6500";
      };
      wallpaper = {
        recursiveSearch = true;
        transitionDuration = 500;
        transitionEdgeSmoothness = 0;
        transitionType = "wipe";
      };
      appLauncher = {
        enableClipboardHistory = true;
        terminalCommand = "${lib.getExe pkgs.wezterm} start --";
        position = "top_center";
        screenshotAnnotationTool = "${lib.getExe pkgs.gradia}";
      };
      plugins = {
        autoUpdate = true;
      };
    };
    pluginSettings = {
      privacy-indicator = {
        hideInactive = true;
      };
      #video-wallpaper = {
      #  activeBackend = "mpvpaper";
      #  hardwareAcceleration = true;
      #  profile = "default"; # "default", "fast", "high-quality", or "low-latency"
      #  volume = 0;
      #  #wallpapersFolder = "~/Pictures/Wallpapers";
      #};
    };
  };

  systemd.user.services.noctalia-shell = {
    Unit = {
      ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
    };
  };

  home.packages = with pkgs; [
    cliphist
    mpvpaper
  ];
}
