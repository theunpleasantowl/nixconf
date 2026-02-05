{
  config,
  lib,
  ...
}:
let
  cfg = config.features.linux.desktop;
in
{
  config = lib.mkIf cfg.anyEnabled {
    programs = {
      firefox = {
        enable = true;
        preferences = {
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };
      };

      thunderbird = {
        enable = true;
      };
    };
  };
}
