{ config, lib, ... }:
lib.mkIf config.features.linux.networks.enable {
  networking.networkmanager.ensureProfiles.profiles.neptune = {
    connection = {
      id = "Neptune";
      type = "wifi";
    };
    wifi = {
      ssid = "Neptune";
      mode = "infrastructure";
    };
    wifi-security = {
      key-mgmt = "wpa-psk";
      psk = "$NEPTUNE_PSK";
    };
    ipv4.method = "auto";
    ipv6.method = "auto";
  };
}
