{pkgs, ...}: {
  # Snapshots of user directories
  services.snapper = {
    configs = {
      home = {
        SUBVOLUME = "/home";
        ALLOW_USERS = ["hibiki"];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;

        TIMELINE_LIMIT_HOURLY = "24";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "6";
        TIMELINE_LIMIT_YEARLY = "2";
      };
    };
    snapshotInterval = "hourly";
  };

  systemd.services.snapper-timeline = {
    enable = true;
  };
  systemd.services.snapper-cleanup = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    snapper
  ];
}
