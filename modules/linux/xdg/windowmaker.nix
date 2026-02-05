{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.desktop.windowmaker;
in
{
  options.features.linux.desktop.windowmaker = {
    enable = lib.mkEnableOption "WindowMaker X11 window manager";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.windowManager.windowmaker.enable = true;

    environment.systemPackages =
      with pkgs;
      [
        gworkspace
      ]
      ++ (with pkgs.windowmaker.dockapps; [
        AlsaMixer-app
        wmCalClock
        wmcube
        wmsm-app
        wmsystemtray
      ]);
  };
}
