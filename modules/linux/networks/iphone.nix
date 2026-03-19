{ config, lib, ... }:
lib.mkIf config.features.linux.networks.enable {
  networking.networkmanager.ensureProfiles.profiles.iphone = {
    connection = {
      id = "iPhone";
      type = "wifi";
    };
    wifi = {
      ssid = "iPhone";
      mode = "infrastructure";
    };
    wifi-security = {
      key-mgmt = "wpa-psk";
      psk = "$IPHONE_PSK";
    };
    ipv4.method = "auto";
    ipv6.method = "auto";
  };
}
