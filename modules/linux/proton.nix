{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.proton;

  proton = pkgs.proton-ge-bin.steamcompattool;

  umu-launcher = pkgs.umu-launcher.override {
    extraEnv = {
      PROTONPATH = "${proton}";
    };
  };

  proton-desktop = pkgs.makeDesktopItem {
    name = "proton";
    desktopName = "Proton";
    genericName = "Windows Compatibility Layer";
    comment = "Run Windows applications with Proton (umu-launcher)";
    exec = "${umu-launcher}/bin/umu-run %f";
    categories = [ "Utility" ];
    mimeTypes = [
      "application/x-ms-dos-executable"
      "application/x-msdownload"
    ];
  };
in
{
  options.features.linux.proton = {
    enable = lib.mkEnableOption "Standalone Proton and related tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      umu-launcher
      proton-desktop
    ];

    xdg.mime.defaultApplications = {
      "application/x-ms-dos-executable" = "proton.desktop";
      "application/x-msdownload" = "proton.desktop";
    };
  };
}
