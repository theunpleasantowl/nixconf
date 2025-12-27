{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.gaming;
in {
  options.features.gaming = {
    enable = lib.mkEnableOption "gaming support";

    steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable Steam";
      };
    };

    wine = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable Wine and related tools";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.steam.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [proton-ge-bin];
      };

      programs.gamemode.enable = true;

      environment.systemPackages = with pkgs; [
        mangohud
        steam-run
      ];
    })

    (lib.mkIf cfg.wine.enable {
      environment.systemPackages = with pkgs; [
        bottles
        wineWowPackages.stagingFull
        winetricks
      ];
    })
  ];
}
