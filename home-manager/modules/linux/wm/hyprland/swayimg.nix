{ ... }:
{
  programs.swayimg = {
    enable = true;
    settings = {
      viewer = {
        window = "#10000010";
        scale = "fill";
      };
      "info.viewer" = {
        top_left = "+name,+format";
      };

      # https://github.com/artemsen/swayimg/blob/master/extra/swayimgrc
      "keys.gallery" = {
        "h" = "step_left";
        "j" = "step_down";
        "k" = "step_up";
        "l" = "step_right";
      };
      "keys.viewer" = {
        "n" = "next_file";
        "p" = "prev_file";

        "f" = "toggle_fullscreen";
        "q" = "exit";
        "Esc" = "exit";
      };
    };
  };
}
