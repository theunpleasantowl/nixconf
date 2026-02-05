{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.gaming;
  retroarchWithCores = pkgs.retroarch.withCores (
    cores: with cores; [
      beetle-pce
      beetle-psx
      beetle-saturn
      beetle-vb
      beetle-wswan
      bluemsx
      bsnes
      citra
      dolphin
      flycast
      genesis-plus-gx
      melonds
      mesen
      mgba
      mupen64plus
      np2kai
      pcsx2
      ppsspp
      sameboy
    ]
  );
in
{
  options.features.gaming = {
    enable = lib.mkEnableOption "Enable gaming tools and emulators";

    retroarch = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable RetroArch with cores";
    };

    emulators = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable standalone emulators (Dolphin, RPCS3, etc.)";
    };

    extraGames = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable extra games like SRB2";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      lib.concatLists [
        (lib.optionals cfg.retroarch [
          retroarchWithCores
        ])
        (lib.optionals cfg.emulators [
          dolphin-emu
          rpcs3
        ])
        (lib.optionals cfg.extraGames [
          srb2
          srb2kart
        ])
      ];
  };
}
