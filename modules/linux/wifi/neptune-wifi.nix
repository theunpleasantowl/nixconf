{ config, lib, ... }:
lib.mkIf config.features.linux.wifi.enable {
  networking.networkmanager.ensureProfiles.profiles.neptune = {
    connection = {
      id = "$NEPTUNE_SSID";
      type = "wifi";
    };
    wifi = {
      ssid = "$NEPTUNE_SSID";
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
