{pkgs, ...}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "main";
    sha256 = "sha256-enIt79UvQnKJalBtzSEdUkjNHjNJuKUWC4L6QFb3Ou4=";
  };
in {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        #show_hidden = true;
      };
    };

    plugins = {
      chmod = "${yazi-plugins}/chmod.yazi";
      diff = "${yazi-plugins}/diff.yazi";
      git = "${yazi-plugins}/git.yazi";
      max-preview = "${yazi-plugins}/max-preview.yazi";
      mount = "${yazi-plugins}/mount.yazi";
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "main";
        sha256 = "sha256-5QQsFozbulgLY/Gl6QuKSOTtygULveoRD49V00e0WOw=";
      };
    };

    initLua = ''
      require("starship"):setup()
    '';

    keymap = {
      manager.prepend_keymap = [
        {
          on = "T";
          run = "plugin --sync max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = ["c" "d"];
          run = "plugin diff";
          desc = "Diff the selected with the hovered file";
        }
        {
          on = "M";
          run = "plugin mount";
          desc = "Mount manager";
        }
        {
          on = ["W"];
          run = "shell 'set_paper \"$@\"' --orphan --confirm";
          desc = "Set wallpaper";
        }
      ];
    };
  };
}
