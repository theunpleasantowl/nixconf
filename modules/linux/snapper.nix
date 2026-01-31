{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.snapper;
in
{
  options.features.linux.snapper = {
    enable = lib.mkEnableOption "Snapper snapshots for btrfs";

    configs = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              subvolume = lib.mkOption {
                type = lib.types.str;
                description = "Btrfs subvolume path for Snapper config '${name}'.";
                example = "/home";
              };

              timeline = {
                hourly = lib.mkOption {
                  type = lib.types.str;
                  default = "24";
                };
                daily = lib.mkOption {
                  type = lib.types.str;
                  default = "7";
                };
                weekly = lib.mkOption {
                  type = lib.types.str;
                  default = "4";
                };
                monthly = lib.mkOption {
                  type = lib.types.str;
                  default = "6";
                };
              };
            };
          }
        )
      );

      default = { };
      description = ''
        Snapper configurations keyed by config name.
        Each entry maps to services.snapper.configs.<name>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.configs != { };
        message = "features.linux.snapper.enable is true, but no configs were defined.";
      }
    ];

    services.snapper = {
      configs = lib.mapAttrs (_name: c: {
        SUBVOLUME = c.subvolume;

        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;

        TIMELINE_LIMIT_HOURLY = c.timeline.hourly;
        TIMELINE_LIMIT_DAILY = c.timeline.daily;
        TIMELINE_LIMIT_WEEKLY = c.timeline.weekly;
        TIMELINE_LIMIT_MONTHLY = c.timeline.monthly;
      }) cfg.configs;

      snapshotInterval = "hourly";
    };

    systemd.services.snapper-timeline.enable = true;
    systemd.services.snapper-cleanup.enable = true;

    environment.systemPackages = with pkgs; [
      snapper
    ];
  };
}
