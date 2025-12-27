{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.desktop;

  desktops = {
    gnome = {
      enable = cfg.gnome.enable;
    };
    hyprland = {
      enable = cfg.hyprland.enable;
    };
    cosmic = {
      enable = cfg.cosmic.enable;
    };
    windowmaker = {
      enable = cfg.windowmaker.enable;
      needsXServer = true;
    };
  };

  # Filtering functions check if attribute exists AND is true
  anyEnabled = builtins.any (d: d.enable) (builtins.attrValues desktops);
  anyNeedsXServer = builtins.any (d: d.enable && (d.needsXServer or false)) (
    builtins.attrValues desktops
  );
in {
  options.features.desktop = {
    gnome = {
      enable = lib.mkEnableOption "GNOME desktop";
      useGdm = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use GDM display manager";
      };
    };

    hyprland = {
      enable = lib.mkEnableOption "Hyprland compositor";
    };

    cosmic = {
      enable = lib.mkEnableOption "COSMIC desktop";
      useCosmicGreeter = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use COSMIC display manager";
      };
    };

    windowmaker = {
      enable = lib.mkEnableOption "WindowMaker X11 window manager";
    };

    utilities = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        firefox
        thunderbird
        mpv
      ];
      description = "Common desktop utilities to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf anyEnabled {
      hardware.graphics.enable = true;
      environment.systemPackages = cfg.utilities;
    })

    (lib.mkIf anyNeedsXServer {
      services.xserver = {
        enable = true;
        excludePackages = [pkgs.xterm];
      };
    })

    # GNOME
    (lib.mkIf cfg.gnome.enable {
      services.displayManager.gdm.enable = cfg.gnome.useGdm;
      services.desktopManager.gnome.enable = true;

      environment.systemPackages = with pkgs; [
        ffmpegthumbnailer
        foliate
        ghostty
        gnome-epub-thumbnailer
        gnomeExtensions.appindicator
        gnomeExtensions.blur-my-shell
        gnomeExtensions.clipboard-indicator
        gnomeExtensions.dash-to-dock
        gnomeExtensions.gamemode-shell-extension
        gnomeExtensions.kimpanel
        gnomeExtensions.media-controls
        gnomeExtensions.tiling-shell
        gnomeExtensions.tophat
        komikku
        mission-center
        nautilus-python
      ];

      environment.gnome.excludePackages = with pkgs; [
        epiphany
        geary
        gnome-console
        gnome-music
        gnome-system-monitor
        gnome-tour
        gnome-user-docs
        showtime
        totem
      ];
    })

    # Hyprland
    (lib.mkIf cfg.hyprland.enable {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
      programs.hyprlock.enable = true;
      services.hypridle.enable = true;
      security.polkit.enable = true;
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      services.udisks2.enable = true;

      environment.systemPackages = with pkgs; [
        swww
        waybar
        wl-clipboard
      ];
    })

    # COSMIC
    (lib.mkIf cfg.cosmic.enable {
      services.displayManager.cosmic-greeter.enable = cfg.cosmic.useCosmicGreeter;
      services.desktopManager.cosmic.enable = true;
    })

    # WindowMaker
    (lib.mkIf cfg.windowmaker.enable {
      services.xserver.windowManager.windowmaker.enable = true;

      environment.systemPackages = with pkgs;
        [
          gworkspace
        ]
        ++ (with pkgs.windowmaker.dockapps; [
          alsamixer-app
          wmcalclock
          wmcube
          wmsm
          wmsystemtray
        ]);
    })
  ];
}
