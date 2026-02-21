{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.features.gaming;
  retroarchWithCores = pkgs.retroarch;
  #dolphinEmu = pkgs.dolphin;
  #rpcs3Emu = pkgs.rpcs3;
in
{
  options.features.gaming = {
    enable = lib.mkEnableOption "Enable gaming tools";

    retroarch = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable RetroArch";
    };

    emulators = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable standalone emulators like Dolphin, RPCS3";
    };

    extraGames = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable extra games (e.g., SRB2)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.concatLists [
      (lib.optionals cfg.retroarch [
        retroarchWithCores
      ])
      (lib.optionals cfg.emulators [
        #dolphinEmu
        #rpcs3Emu
      ])
      (lib.optionals cfg.extraGames [
        #pkgs.srb2
      ])
    ];
  };

}
