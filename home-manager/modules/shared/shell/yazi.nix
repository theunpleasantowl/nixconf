{
  pkgs,
  lib,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    plugins = {
      "chmod" = pkgs.yaziPlugins.chmod;
      "diff" = pkgs.yaziPlugins.diff;
      "glow" = pkgs.yaziPlugins.glow;
      "lazygit" = pkgs.yaziPlugins.lazygit;
      "miller" = pkgs.yaziPlugins.miller;
      "mount" = pkgs.yaziPlugins.mount;
      "restore" = pkgs.yaziPlugins.lazygit;
      "starship" = pkgs.yaziPlugins.starship;
      "sudo" = pkgs.yaziPlugins.sudo;
    };
    initLua = ''
      require("starship"):setup()
    '';
    settings = {
      mgr = {
        #show_hidden = true;
      };
      keymap = [
        {
          manager.prepend_keymap = [
            # Keybindings for the 'sudo' plugin
            {
              on = [
                "R"
                "p"
                "p"
              ];
              run = "plugin sudo --args='paste'";
              desc = "sudo paste";
            }
            {
              on = [
                "R"
                "P"
              ];
              run = "plugin sudo --args='paste --force'";
              desc = "sudo paste (force)";
            }
            {
              on = [
                "R"
                "r"
              ];
              run = "plugin sudo --args='rename'";
              desc = "sudo rename";
            }
            {
              on = [
                "R"
                "p"
                "l"
              ];
              run = "plugin sudo --args='link'";
              desc = "sudo link (absolute-path)";
            }
            {
              on = [
                "R"
                "p"
                "r"
              ];
              run = "plugin sudo --args='link --relative'";
              desc = "sudo link (relative-path)";
            }
            {
              on = [
                "R"
                "p"
                "L"
              ];
              run = "plugin sudo --args='hardlink'";
              desc = "sudo hardlink";
            }
            {
              on = [
                "R"
                "a"
              ];
              run = "plugin sudo --args='create'";
              desc = "sudo create (touch/mkdir)";
            }
            {
              on = [
                "R"
                "d"
              ];
              run = "plugin sudo --args='remove'";
              desc = "sudo trash";
            }
            {
              on = [
                "R"
                "D"
              ];
              run = "plugin sudo --args='remove --permanently'";
              desc = "sudo delete";
            }
            # Keybinding for the 'diff' plugin
            {
              on = "<C-d>";
              run = "plugin diff";
              desc = "Diff the selected with the hovered file";
            }
            # Keybinding for the 'mount' plugin
            {
              on = "M";
              run = "plugin mount";
              desc = "Mount manager";
            }
            # Keybinding for the 'chmod' plugin
            {
              on = [
                "c"
                "m"
              ];
              run = "plugin chmod";
              desc = "Chmod on selected files";
            }
          ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            # Keybinding for mpvpaper (Linux only)
            {
              on = "W";
              run = "shell ${pkgs.mpvpaper}/bin/mpvpaper -o 'no-audio loop' '*' \"$1\" --confirm";
              desc = "Set as wallpaper with mpvpaper";
            }
          ];
        }
      ];
    };
  };
}
