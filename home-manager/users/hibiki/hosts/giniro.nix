{ osConfig ? null, lib, ... }:
lib.mkIf ((osConfig.networking.hostName or null) == "giniro") {
  features.gaming.emulators = lib.mkForce false;
}
