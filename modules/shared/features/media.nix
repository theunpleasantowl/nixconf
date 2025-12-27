{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.media;
in {
  options.features.media = {
    enable = lib.mkEnableOption "media production tools";

    video = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable video editing tools";
      };
    };

    graphics = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;

        description = "Enable graphics/image editing tools";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      lib.optionals cfg.video.enable [
        kdePackages.kdenlive
        obs-studio
      ]
      ++ lib.optionals cfg.graphics.enable [
        gimp3-with-plugins
      ];
  };
}
