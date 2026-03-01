{
  config,
  lib,
  ...
}:
let
  cfg = config.features.docker;
in
{
  options.features.docker = {
    enable = lib.mkEnableOption "Docker";

    storageDriver = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "overlay2"
          "btrfs"
          "zfs"
          "vfs"
        ]
      );
      default = null;
      description = ''
        Docker storage driver. Set to null to let Docker auto-detect
        based on the underlying filesystem.
      '';
    };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of users to add to the docker group.";
      example = [
        "alice"
        "bob"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = cfg.storageDriver;
    };

    users.users = lib.mkMerge (
      map (user: {
        ${user}.extraGroups = [ "docker" ];
      }) cfg.users
    );
  };
}
