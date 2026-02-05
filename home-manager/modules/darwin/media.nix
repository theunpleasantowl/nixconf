{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.media;
in
{
  options.features.media = {
    enable = lib.mkEnableOption "Enable media applications";

    video = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable video editing tools";
    };

    graphics = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable graphics/image editing tools";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.concatLists [
      (lib.optionals cfg.video.enable [
        pkgs.homebrew.packages.kdenlive
        pkgs.homebrew.packages.mpv
        pkgs.homebrew.packages.obs
      ])
      (lib.optionals cfg.graphics.enable [
        pkgs.homebrew.packages.gimp
      ])
    ];
  };
}
