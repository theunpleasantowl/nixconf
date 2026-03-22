{ config, lib, ... }:
let
  cfg = config.features.linux.networks;
in
{
  options.features.linux.networks = {
    enable = lib.mkEnableOption "managed WiFi and VPN profiles";
  };

  imports =
    with builtins;
    map (fn: ./${fn}) (
      filter (fn: fn != "default.nix") (attrNames (readDir ./.))
    );

  config = lib.mkIf cfg.enable {
    sops.secrets."networks/env" = {
      restartUnits = [ "NetworkManager-ensure-profiles.service" ];
    };
    networking.networkmanager.ensureProfiles.environmentFiles = [
      config.sops.secrets."networks/env".path
    ];
  };
}
