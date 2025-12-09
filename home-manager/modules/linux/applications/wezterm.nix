{...}: let
  weztermConfig = ./wezterm-config;
in {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  home.file = {
    # Main config
    #".config/wezterm/wezterm.lua".source = "${weztermConfig}/wezterm.lua";
    ".config/wezterm/config-selector.lua".source = "${weztermConfig}/config-selector.lua";

    # Fonts
    ".config/wezterm/fonts/bigblue.lua".source = "${weztermConfig}/fonts/bigblue.lua";
    ".config/wezterm/fonts/blex.lua".source = "${weztermConfig}/fonts/blex.lua";
    ".config/wezterm/fonts/firacode.lua".source = "${weztermConfig}/fonts/firacode.lua";
    ".config/wezterm/fonts/gohufont.lua".source = "${weztermConfig}/fonts/gohufont.lua";
    ".config/wezterm/fonts/heavydata.lua".source = "${weztermConfig}/fonts/heavydata.lua";
    ".config/wezterm/fonts/sauce-code-pro.lua".source = "${weztermConfig}/fonts/sauce-code-pro.lua";
    ".config/wezterm/fonts/terminess.lua".source = "${weztermConfig}/fonts/terminess.lua";

    # Inactive panes
    ".config/wezterm/inactivepanes/variants.lua".source = "${weztermConfig}/inactivepanes/variants.lua";

    # Leadings
    ".config/wezterm/leadings/leadings.lua".source = "${weztermConfig}/leadings/leadings.lua";

    # Opacity
    ".config/wezterm/opacity/opacity.lua".source = "${weztermConfig}/opacity/opacity.lua";

    # Sizes
    ".config/wezterm/sizes/sizes.lua".source = "${weztermConfig}/sizes/sizes.lua";
  };
}
