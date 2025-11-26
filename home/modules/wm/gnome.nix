{pkgs, ...}: {
  programs.gnome-shell = {
    extensions = with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
      clipboard-indicator
      dash-to-dock
      night-theme-switcher
      pip-on-top
      tiling-shell
      tophat
    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/mutter" = {
        experimental-features = ["variable-refresh-rate"];
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };
      "org/gnome/desktop/interface" = {
        accent-color = "purple";
      };
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
      };
      "org/gnome/system/location" = {
        enabled = true;
      };
      "org/gnome/desktop/datetime" = {
        automatic-timezone = true;
      };
      "org/gtk/settings/file-chooser" = {
        clock-format = "12h";
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = true;
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>e";
        command = "nautilus";
        name = "Launch Files";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "<Super>t";
        command = "ghostty";
        name = "Launch Terminal";
      };
      "org/gnome/shell" = {
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "blur-my-shell@aunetx"
          "clipboard-indicator@tudmotu.com"
          "dash-to-dock@micxgx.gmail.com"
          "dock-from-dash@fthx"
          "kimpanel@kde.org"
          "nightthemeswitcher@romainvigier.fr"
          "pip-on-top@rafostar.github.com"
          "tilingshell@favo02.github.com"
          "tilingshell@ferrarodomenico.com"
          "tophat@fflewddur.github.io"
        ];
      };
      "org/gnome/shell/extensions/clipboard-indicator" = {
        toggle-menu = ["<Shift><Super>v"];
      };
    };
  };
}
