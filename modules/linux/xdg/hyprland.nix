{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.linux.desktop.hyprland;
in {
  options.features.linux.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland compositor";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    #programs.hyprlock.enable = true;
    #services.hypridle.enable = true;
    #programs.hyprpolkitagent.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    services.udisks2.enable = true;
  };
}
