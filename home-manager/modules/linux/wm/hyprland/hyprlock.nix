{ lib, ... }:
{
  programs.hyprlock = {
    #enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 0;
        no_fade_in = false;
      };

      background = lib.mkDefault [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = lib.mkDefault [
        {
          size = "300, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = lib.mkDefault "rgb(202, 211, 245)";
          inner_color = lib.mkDefault "rgb(91, 96, 120)";
          outer_color = lib.mkDefault "rgb(24, 25, 38)";
          outline_thickness = 3;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b><big> $(date +\"%H:%M\") </big></b>\"";
          color = lib.mkDefault "rgb(202, 211, 245)";
          font_size = 64;
          font_family = "FiraCode Nerd Font";
          position = "0, 16";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:18000000] echo \"<b> $(date +\"%A, %B %d\") </b>\"";
          color = lib.mkDefault "rgb(202, 211, 245)";
          font_size = 24;
          font_family = "FiraCode Nerd Font";
          position = "0, -16";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
