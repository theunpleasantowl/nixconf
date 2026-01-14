{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.features.linux.plymouth;
in {
  options.features.linux.plymouth = {
    enable =
      lib.mkEnableOption "silent boot with Plymouth"
      // {
        default = true;
      };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      plymouth.enable = true;

      consoleLogLevel = 0;
      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];

      # Hide the OS choice for bootloaders.
      # Menu appears only if a key is pressed.
      loader.timeout = 0;
    };
  };
}
