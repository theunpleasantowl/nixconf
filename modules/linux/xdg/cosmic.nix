{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.desktop.cosmic;
in
{
  options.features.linux.desktop.cosmic = {
    enable = lib.mkEnableOption "COSMIC desktop";

    useCosmicGreeter = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use COSMIC greeter";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.cosmic-greeter.enable = cfg.useCosmicGreeter;
    services.desktopManager.cosmic.enable = true;
  };
}
