{ config, lib, ... }:
{
  options.features.linux = {
    printing = {
      enable = lib.mkEnableOption "Printing support (CUPS)";
    };

    bluetooth = {
      enable = lib.mkEnableOption "Bluetooth support";

      powerOnBoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Power on Bluetooth controller at boot";
      };

      blueman = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Blueman GUI manager";
      };
    };

    fwupd = {
      enable = lib.mkEnableOption "Firmware update daemon (fwupd)";
    };
  };

  config = lib.mkMerge [

    (lib.mkIf config.features.linux.printing.enable {
      services.printing.enable = true;
      services.avahi.enable = true;
      services.avahi.nssmdns4 = true;
    })

    (lib.mkIf config.features.linux.bluetooth.enable {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = config.features.linux.bluetooth.powerOnBoot;

      services.blueman.enable = config.features.linux.bluetooth.blueman;
    })

    (lib.mkIf config.features.linux.fwupd.enable {
      services.fwupd.enable = true;
    })
  ];
}
