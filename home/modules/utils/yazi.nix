{pkgs, ...}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "7458b6c";
    sha256 = "sha256-TO6omlE92wO4bTKWWjsXBxTc1aeh6jreYI1xudF9/wo=";
  };
in {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        show_hidden = true;
      };
    };

    plugins = {
      chmod = "${yazi-plugins}/chmod.yazi";
      max-preview = "${yazi-plugins}/max-preview.yazi";
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "77a65f5a367f833ad5e6687261494044006de9c3";
        sha256 = "sha256-sAB0958lLNqqwkpucRsUqLHFV/PJYoJL2lHFtfHDZF8=";
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
          on = ["W"];
          run = "shell 'swww img -t outer \"$@\"' --confirm";
          desc = "Feed file into swww to set wallpaper";
        }
      ];
    };
  };
}
