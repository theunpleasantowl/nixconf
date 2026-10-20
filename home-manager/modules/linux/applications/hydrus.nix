{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.hydrus;
in
{
  options.features.hydrus = {
    enable = lib.mkEnableOption "Hydrus Network (personal booru-style media tagger) and metadata utilities";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hydrus
      exiftool
    ];
  };
}
