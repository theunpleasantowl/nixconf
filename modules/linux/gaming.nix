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
      # Steam-Play-None bypasses SteamLinuxRuntime/pressure-vessel, which
      # otherwise hides the outer Steam FHS from native games. Needed so
      # Hypnospace Outlaw can dlopen libspeechd.so.2 for Hypii's TTS.
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        steam-play-none
      ];

      # Let native games (e.g. Hypnospace Outlaw) dlopen libspeechd.so.2
      # from inside Steam's FHS environment.
      extraPackages = with pkgs; [ speechd-minimal ];
    };

    programs.gamemode.enable = lib.mkDefault pkgs.stdenv.hostPlatform.isLinux;

    environment.systemPackages =
      with pkgs;
      lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        mangohud
        steam-run
      ];
  };
}
