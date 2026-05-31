{ config, lib, ... }:
let
  cfg = config.features.fingerprint;
in
{
  options.features.fingerprint = {
    enable = lib.mkEnableOption "fingerprint scanner support";

    tod = {
      enable = lib.mkEnableOption "fprintd Touch OEM Driver support";

      driver = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        description = "Optional fprintd TOD driver package for scanners that need one.";
        example = lib.literalExpression "pkgs.libfprint-2-tod1-goodix";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.fprintd = {
          enable = true;
          tod.enable = cfg.tod.enable;
        };
      }

      (lib.mkIf (cfg.tod.driver != null) {
        services.fprintd.tod.driver = cfg.tod.driver;
      })
    ]
  );
}
