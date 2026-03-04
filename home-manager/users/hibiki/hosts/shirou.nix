{ osConfig, lib, ... }:
lib.mkIf (osConfig.networking.hostName == "shirou") {
  features.ide.enable = false;
}
