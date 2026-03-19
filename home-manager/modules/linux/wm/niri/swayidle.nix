{ pkgs, lib, ... }:
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "loginctl lock-session";
      }
      {
        event = "lock";
        command = "noctalia-shell ipc call lockScreen lock";
      }
      {
        event = "after-resume";
        command = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
    ];

    timeouts = [
      {
        timeout = 300;
        command = "loginctl lock-session";
      }
      {
        timeout = 330;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
      }
      {
        timeout = 900;
        command = "systemctl suspend";
      }
    ];
  };
  systemd.user.services.swayidle = {
    Unit = {
      ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=niri";
    };
  };
}
