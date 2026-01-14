{
  lib,
  pkgs,
  ...
}: {
  programs.wlogout = {
    #enable = true;
    layout = [
      {
        label = "lock";
        action = "${lib.getExe pkgs.hyprlock}";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];

    style = ''
      * {
        background-image: none;
        box-shadow: none;
      }

      window {
        background-color: rgba(30, 30, 46, 0.9);
      }

      button {
        color: #cdd6f4;
        background-color: rgba(49, 50, 68, 0.8);
        border-radius: 10px;
        border: 2px solid #89b4fa;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        margin: 20px;
      }

      button:focus, button:active, button:hover {
        background-color: rgba(137, 180, 250, 0.3);
        outline-style: none;
      }

      #lock {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #reboot {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }
    '';
  };
}
