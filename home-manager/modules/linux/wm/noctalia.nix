{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  useStylix = config.stylix.enable or false;
  colors = config.lib.stylix.colors or { };
  companionTheme = pkgs.writeText "CompanionTheme.qml" ''
    import QtQuick

    QtObject {
      readonly property color bg: "${if useStylix then "#${colors.base00}" else "#0b0a09"}"
      readonly property color bgStrong: "${if useStylix then "#${colors.base01}" else "#0b0a09"}"
      readonly property color fg: "${if useStylix then "#${colors.base05}" else "#c8b89a"}"
      readonly property color fgSoft: "${if useStylix then "#${colors.base04}" else "#a89a7e"}"
      readonly property color border: "${if useStylix then "#${colors.base03}" else "#463f2e"}"
      readonly property color red: "${if useStylix then "#${colors.base08}" else "#c87060"}"
      readonly property color gold: "${if useStylix then "#${colors.base0A}" else "#c8a860"}"
      readonly property color green: "${if useStylix then "#${colors.base0B}" else "#60a880"}"
      readonly property color blue: "${if useStylix then "#${colors.base0D}" else "#6090c8"}"
    }
  '';
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        pomodoro = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        dmenu = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        privacy-indicator = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        video-wallpaper = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        companions = {
          enabled = true;
        };
        "hyprland-visuals" = {
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
        language = "en";
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

  xdg.configFile = {
    "noctalia/plugins/companions/manifest.json".source = ./noctalia-plugins/companions/manifest.json;
    "noctalia/plugins/companions/Main.qml".source = ./noctalia-plugins/companions/Main.qml;
    "noctalia/plugins/companions/CompanionIPC.qml".source =
      ./noctalia-plugins/companions/CompanionIPC.qml;
    "noctalia/plugins/companions/Settings.qml".source = ./noctalia-plugins/companions/Settings.qml;
    "noctalia/plugins/companions/Companions.qml".source = ./noctalia-plugins/companions/Companions.qml;
    "noctalia/plugins/companions/CompanionArrow.qml".source =
      ./noctalia-plugins/companions/CompanionArrow.qml;
    "noctalia/plugins/companions/CompanionTheme.qml".source = companionTheme;
    "noctalia/plugins/companions/assets/2b.gif".source = ./noctalia-plugins/companions/assets/2b.gif;
    "noctalia/plugins/companions/assets/amazon.gif".source =
      ./noctalia-plugins/companions/assets/amazon.gif;
    "noctalia/plugins/companions/assets/mai.gif".source = ./noctalia-plugins/companions/assets/mai.gif;
    "noctalia/plugins/hyprland-visuals/manifest.json" = {
      source = ./noctalia-plugins/hyprland-visuals/manifest.json;
      force = true;
    };
    "noctalia/plugins/hyprland-visuals/HyprlandVisualsResetController.qml" = {
      source = ./noctalia-plugins/hyprland-visuals/HyprlandVisualsResetController.qml;
      force = true;
    };
    "noctalia/plugins/hyprland-visuals/HyprlandVisualsResetPanel.qml" = {
      source = ./noctalia-plugins/hyprland-visuals/HyprlandVisualsResetPanel.qml;
      force = true;
    };
  };

  #  systemd.user.services.noctalia-shell = {
  #    Unit = {
  #      ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
  #    };
  #  };

  home.packages = with pkgs; [
    cliphist
  ];
}
