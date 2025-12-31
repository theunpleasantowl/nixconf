{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wm.gnome;

  gnomeExtensions = [
    {
      pkg = pkgs.gnomeExtensions.appindicator;
      uuid = "appindicatorsupport@rgcjonas.gmail.com";
    }
    {
      pkg = pkgs.gnomeExtensions.blur-my-shell;
      uuid = "blur-my-shell@aunetx";
    }
    {
      pkg = pkgs.gnomeExtensions.caffeine;
      uuid = "caffeine@patapon.info";
    }
    {
      pkg = pkgs.gnomeExtensions.clipboard-indicator;
      uuid = "clipboard-indicator@tudmotu.com";
    }
    {
      pkg = pkgs.gnomeExtensions.dash-to-dock;
      uuid = "dash-to-dock@micxgx.gmail.com";
    }
    {
      pkg = pkgs.gnomeExtensions.pip-on-top;
      uuid = "pip-on-top@rafostar.github.io";
    }
    {
      pkg = pkgs.gnomeExtensions.tiling-shell;
      uuid = "tilingshell@favo02.github.com";
    }
    {
      pkg = pkgs.gnomeExtensions.tophat;
      uuid = "tophat@fflewddur.github.io";
    }
    {
      pkg = pkgs.gnomeExtensions.media-controls;
      uuid = "mediacontrols@cliffniff.github.com";
    }
    {
      pkg = pkgs.gnomeExtensions.kimpanel;
      uuid = "kimpanel@kde.org";
    }
  ];
  enabledExtensions = lib.optionals cfg.extensions.enable gnomeExtensions;
in {
  options.wm.gnome = {
    enable = lib.mkEnableOption "Enable GNOME desktop environment";

    # Desktop behavior options
    hotCorners = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable hot corners";
    };

    nightLight = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable night light";
    };

    automaticTimezone = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable automatic timezone detection";
    };

    vrr = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable variable refresh rate (VRR) for GNOME";
    };

    # Keybindings
    keybindings = {
      fileManager = lib.mkOption {
        type = lib.types.str;
        default = "<Super>e";
        description = "Keybinding to launch the file manager";
      };

      terminal = lib.mkOption {
        type = lib.types.str;
        default = "<Super>t";
        description = "Keybinding to launch the terminal";
      };

      terminalCommand = lib.mkOption {
        type = lib.types.str;
        default = "ghostty";
        description = "Command to run for the terminal keybinding";
      };
    };

    # GNOME Shell extensions
    extensions.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GNOME Shell extensions";
    };

    # Favorite applications
    favoriteApps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "thunderbird.desktop"
        "com.mitchellh.ghostty.desktop"
        "steam.desktop"
        "com.libretro.RetroArch.desktop"
        "vesktop.desktop"
        "joplin.desktop"
        "anki.desktop"
        "dev.zed.Zed.desktop"
      ];
      description = "List of favorite GNOME Shell applications";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable dconf and GNOME Shell
    dconf.enable = true;
    programs.gnome-shell.enable = true;

    # Extensions (list of submodules)
    programs.gnome-shell.extensions = map (e: {package = e.pkg;}) enabledExtensions;

    # dconf settings
    dconf.settings = lib.mkMerge [
      # VRR
      (lib.mkIf cfg.vrr {
        "org/gnome/mutter".experimental-features = ["variable-refresh-rate"];
      })

      # General GNOME settings
      {
        "org/gnome/desktop/interface".enable-hot-corners = cfg.hotCorners;

        "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";

        "org/gnome/desktop/wm/keybindings" = {
          switch-applications = [];
          switch-applications-backward = [];
          switch-windows = ["<Alt>Tab"];
          switch-windows-backward = ["<Shift><Alt>Tab"];
        };

        "org/gnome/shell".enabled-extensions = map (e: e.uuid) enabledExtensions;
        "org/gnome/shell".favorite-apps = cfg.favoriteApps;

        "org/gtk/settings/file-chooser".clock-format = "12h";

        # Custom keybindings
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = cfg.keybindings.fileManager;
          command = "nautilus";
          name = "Launch Files";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = cfg.keybindings.terminal;
          command = cfg.keybindings.terminalCommand;
          name = "Launch Terminal";
        };

        "org/gnome/shell/extensions/clipboard-indicator".toggle-menu = ["<Shift><Super>v"];

        "org/gnome/shell/extensions/mediacontrols" = {
          extension-position = "Left";
          extension-index = lib.hm.gvariant.mkUint32 1;
        };
      }

      # Automatic timezone
      (lib.mkIf cfg.automaticTimezone {
        "org/gnome/system/location".enabled = true;
        "org/gnome/desktop/datetime".automatic-timezone = true;
      })

      # Night light
      (lib.mkIf cfg.nightLight {
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
          night-light-schedule-automatic = true;
        };
      })
    ];
  };
}
