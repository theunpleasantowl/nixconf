{ lib, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        #lock_cmd = "pidof hyprlock || hyprlock";
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch 'hl.dsp.dpms(\"on\")'";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms(\"off\")'";
          on-resume = "hyprctl dispatch 'hl.dsp.dpms(\"on\")'";
        }
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  # Make hypridle Hyprland-only
  systemd.user.services.hypridle = {
    Unit = {
      ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
    };
  };
}
