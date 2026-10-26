{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.flatpak;
in
{
  options.features.flatpak = {
    enable = lib.mkEnableOption "Flatpak";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    environment.systemPackages = with pkgs; [
      flatpak
    ];
  };
}
