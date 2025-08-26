{pkgs, ...}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "71c4fc2e6fa1d6f70c85bf525842d6888d1ffa46";
    sha256 = "sha256-X3R5bsnzGv1TVXOKdhAyspDMguVAyc9tvCxJlypUUAA=";
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
      git = "${yazi-plugins}/git.yazi";
      max-preview = "${yazi-plugins}/max-preview.yazi";
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "9c37d37099455a44343f4b491d56debf97435a0e";
        sha256 = "sha256-wESy7lFWan/jTYgtKGQ3lfK69SnDZ+kDx4K1NfY4xf4=";
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
          run = "shell 'set_paper \"$@\"' --orphan --confirm";
          desc = "Set wallpaper";
        }
      ];
    };
  };
}
