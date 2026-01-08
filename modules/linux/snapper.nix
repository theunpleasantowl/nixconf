{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.linux.snapper;
in {
  options.features.linux.snapper = {
    enable = lib.mkEnableOption "Snapper snapshots for btrfs";
  };

  config = lib.mkIf cfg.enable {
    services.snapper = {
      configs = {
        home = {
          SUBVOLUME = "/home";
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_LIMIT_HOURLY = "24";
          TIMELINE_LIMIT_DAILY = "7";
          TIMELINE_LIMIT_WEEKLY = "4";
          TIMELINE_LIMIT_MONTHLY = "6";
        };
      };
      snapshotInterval = "hourly";
    };

    systemd.services.snapper-timeline.enable = true;
    systemd.services.snapper-cleanup.enable = true;

    environment.systemPackages = with pkgs; [
      snapper
    ];
  };
}
