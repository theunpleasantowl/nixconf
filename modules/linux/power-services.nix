# Once Hibernation has been enabled on a host,
# enable this module's rules with the following:
# `features.linux.powerManagement.enable = true;`

{ config, lib, ... }:
{
  options.features.linux.powerManagement = {
    enable = lib.mkEnableOption "power management settings";
  };

  config = lib.mkIf config.features.linux.powerManagement.enable {
    powerManagement.enable = true;
    services.power-profiles-daemon.enable = true;

    services.logind.settings.Login = {
      LidSwitch = "suspend-then-hibernate";
      PowerKey = "hibernate";
      PowerKeyLongPress = "poweroff";
    };

    boot.kernelParams = [ "mem_sleep_default=deep" ];

    systemd.sleep.settings.Sleep = {
      HibernateDelaySec = "30m";
      HibernateMode = "platform";
    };
  };
}
