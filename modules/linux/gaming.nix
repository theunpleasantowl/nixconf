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
    enable = lib.mkEnableOption "gaming support";

    steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
        description = "Enable Steam";
      };
    };
  };

  config = lib.mkIf cfg.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    programs.gamemode.enable = lib.mkDefault pkgs.stdenv.isLinux;

    environment.systemPackages =
      with pkgs;
      lib.optionals pkgs.stdenv.isLinux [
        mangohud
        steam-run
      ];
  };
}
