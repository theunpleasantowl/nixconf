{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.desktop;

  psdThumbnailer = import ../../../packages/psd-thumbnailer { inherit pkgs; };
in
{
  options.features.linux.desktop.thumbnails = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install thumbnailers for desktop file managers.";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        ffmpegthumbnailer
        gdk-pixbuf
        gnome-epub-thumbnailer
        icoextract
        psdThumbnailer
      ];
      description = "Thumbnailer packages to install.";
    };
  };

  config = lib.mkIf (cfg.anyEnabled && cfg.thumbnails.enable) {
    environment.systemPackages = cfg.thumbnails.packages;
  };
}
