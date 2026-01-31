{ lib, ... }:
{
  services.swaync = {
    #enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 600;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "title"
        "dnd"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };
    };

    style = ''
      * {
        font-family = "FiraCode Nerd Font", monospace;
        font-size: 13px;
      }

      .notification-row {
        outline: none;
        margin: 5px;
      }

      .notification {
        background: rgba(30, 30, 46, 0.95);
        border-radius: 10px;
        margin: 5px;
        padding: 10px;
        border: 1px solid rgba(137, 180, 250, 0.3);
      }

      .notification-content {
        margin: 5px;
      }

      .summary {
        color: #cdd6f4;
        font-size: 14px;
        font-weight: bold;
      }

      .body {
        color: #bac2de;
        margin-top: 5px;
      }

      .control-center {
        background: rgba(30, 30, 46, 0.95);
        border-radius: 10px;
        margin: 10px;
        border: 1px solid rgba(137, 180, 250, 0.3);
      }

      .control-center-list {
        background: transparent;
      }

      .widget-title {
        color: #cdd6f4;
        font-size: 16px;
        font-weight: bold;
        margin: 10px;
      }

      .widget-dnd {
        margin: 10px;
        padding: 10px;
        background: rgba(49, 50, 68, 0.5);
        border-radius: 5px;
      }

      .widget-dnd > switch {
        background: rgba(137, 180, 250, 0.3);
        border-radius: 12px;
      }

      .widget-dnd > switch:checked {
        background: #89b4fa;
      }
    '';
  };
  systemd.user.services.swaync = {
    Unit = {
      ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
    };
  };
}
