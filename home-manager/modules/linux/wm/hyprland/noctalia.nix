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
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            { id = "Tray"; }
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
      dock = {
        pinnedApps = [
          "Vesktop"
          "steam"
        ];
      };
    };
    pluginSettings = {
      privacy-indicator = {
        hideInactive = true;
      };
    };
  };

  systemd.user.services.noctalia-shell = {
    Unit = {
      ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
    };
  };

  home.packages = with pkgs; [
    cliphist
  ];
}
