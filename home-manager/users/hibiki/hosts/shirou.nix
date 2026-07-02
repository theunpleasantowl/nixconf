{
  osConfig ? null,
  lib,
  ...
}:
lib.mkIf ((osConfig.networking.hostName or null) == "shirou") {
  features = {
    ide.enable = lib.mkForce false;
  };
}
