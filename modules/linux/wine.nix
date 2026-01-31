{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.wine;
in
{
  options.features.linux.wine = {
    enable = lib.mkEnableOption "Wine and related tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (bottles.override {
        removeWarningPopup = true;
      })
      wineWowPackages.stagingFull
      winetricks
    ];
  };
}
