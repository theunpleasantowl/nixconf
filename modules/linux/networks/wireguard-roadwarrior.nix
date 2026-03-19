{ config, lib, ... }:
lib.mkIf config.features.linux.networks.enable {
  networking.networkmanager.ensureProfiles.profiles.wireguard-roadwarrior = {
    connection = {
      id = "WireGuard RoadWarrior";
      type = "wireguard";
      interface-name = "wg0";
      autoconnect = "false";
    };
    wireguard = {
      private-key = "$WG_ROADWARRIOR_PRIVATE_KEY";
    };
    "wireguard-peer.$WG_ROADWARRIOR_PEER_PUBLIC_KEY" = {
      endpoint = "$WG_ROADWARRIOR_ENDPOINT";
      allowed-ips = "0.0.0.0/0;::/0;";
      preshared-key = "$WG_ROADWARRIOR_PRESHARED_KEY";
    };
    ipv4 = {
      method = "manual";
      address1 = "$WG_ROADWARRIOR_ADDRESS";
      dns = "$WG_ROADWARRIOR_DNS";
    };
    ipv6.method = "disabled";
  };
}
