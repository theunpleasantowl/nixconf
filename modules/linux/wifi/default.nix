{ config, lib, ... }:
let
  cfg = config.features.linux.wifi;
in
{
  options.features.linux.wifi = {
    enable = lib.mkEnableOption "managed WiFi and VPN profiles";
  };

  imports = (import ../../../lib { }).importModuleSiblings ./.;

  config = lib.mkIf cfg.enable {
    sops.secrets."wifi/env" = {
      restartUnits = [ "NetworkManager-ensure-profiles.service" ];
    };
    networking.networkmanager.ensureProfiles.environmentFiles = [
      config.sops.secrets."wifi/env".path
    ];
  };
}
