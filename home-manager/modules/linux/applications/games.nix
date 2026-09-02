{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.gaming;
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
      description = "Enable standalone emulators";
    };

    rpcs3 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable RPCS3";
    };

    extraGames = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable extra games like SRB2";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.retroarch = lib.mkIf cfg.retroarch {
      enable = true;
      cores = {
        beetle-pce.enable = true;
        beetle-psx.enable = true;
        beetle-saturn.enable = true;
        beetle-vb.enable = true;
        beetle-wswan.enable = true;
        bluemsx.enable = true;
        bsnes.enable = true;
        citra.enable = true;
        dolphin.enable = true;
        flycast.enable = true;
        genesis-plus-gx.enable = true;
        melonds.enable = true;
        mesen.enable = true;
        mgba.enable = true;
        mupen64plus.enable = true;
        np2kai.enable = true;
        pcsx2.enable = true;
        ppsspp.enable = true;
        sameboy.enable = true;
      };
    };

    home.packages =
      with pkgs;
      lib.concatLists [
        (lib.optionals cfg.emulators [
          dolphin-emu
        ])
        (lib.optionals cfg.rpcs3 [
          rpcs3
        ])
        (lib.optionals cfg.extraGames [
          srb2
          srb2kart
        ])
      ];
  };
}
