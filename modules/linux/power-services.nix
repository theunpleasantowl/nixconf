# Once Hibernation has been enabled on a host,
# enable this module's rules with the following:
# `modules.powerManagement.enable = true;`

{ config, lib, ... }:
{
  options.modules.powerManagement = {
    enable = lib.mkEnableOption "power management settings";
  };

  config = lib.mkIf config.modules.powerManagement.enable {
    powerManagement.enable = true;
    services.power-profiles-daemon.enable = true;

    services.logind.settings.Login = {
      LidSwitch = "suspend-then-hibernate";
      PowerKey = "hibernate";
      PowerKeyLongPress = "poweroff";
    };

    boot.kernelParams = [ "mem_sleep_default=deep" ];

    systemd.sleep.extraConfig = ''
      HibernateDelaySec=30m
      SuspendState=mem
    '';
  };
}
