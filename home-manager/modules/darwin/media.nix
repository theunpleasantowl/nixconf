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
    enable = lib.mkEnableOption "media applications";

    video = lib.mkEnableOption "video editing tools" // {
      default = cfg.enable;
    };

    graphics = lib.mkEnableOption "graphics and image editing tools" // {
      default = cfg.enable;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optionals cfg.video [
        #pkgs.homebrew.packages.kdenlive
        pkgs.mpv
        #pkgs.homebrew.packages.obs
      ]
      ++ lib.optionals cfg.graphics [
        #pkgs.homebrew.packages.gimp
      ];
  };
}
