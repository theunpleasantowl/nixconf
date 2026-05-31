{ config, lib, ... }:
lib.mkIf config.features.linux.wifi.enable {
  networking.networkmanager.ensureProfiles.profiles.iphone = {
    connection = {
      id = "$IPHONE_SSID";
      type = "wifi";
    };
    wifi = {
      ssid = "$IPHONE_SSID";
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
