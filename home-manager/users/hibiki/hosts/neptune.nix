{
  osConfig ? null,
  lib,
  ...
}:
lib.mkIf ((osConfig.networking.hostName or null) == "neptune") {
  features.gaming.rpcs3 = lib.mkForce false;
}
