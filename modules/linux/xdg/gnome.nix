{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.desktop.gnome;
in
{
  options.features.linux.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop";

    useGdm = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use GDM display manager";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      services.desktopManager.gnome.enable = true;
    }
    (lib.mkIf cfg.useGdm {
      services.displayManager.gdm.enable = true;
    })
    {

    environment.systemPackages =
      with pkgs;
      [
        file-roller
        foliate
        ghostty
        komikku
        mission-center
        nautilus-python
      ]
      ++ (with pkgs.gnomeExtensions; [
        appindicator
        caffeine
        clipboard-indicator
        dash-to-dock
        kimpanel
      ])
      ++ (with pkgs; [
        ffmpegthumbnailer
        gdk-pixbuf
        gnome-epub-thumbnailer
        icoextract
      ]);

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
  }
  ]);
}
