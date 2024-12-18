{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()
      config.front_end = "WebGpu"
      config.audible_bell = "Disabled"
      config.color_scheme = "catppuccin-mocha"
      config.font = wezterm.font "Terminess Nerd Font"
      config.font_size = 12.0
      config.window_background_opacity = 0.85
      config.window_decorations = "NONE"

      config.use_fancy_tab_bar = false
      config.hide_tab_bar_if_only_one_tab = true

      return config
    '';
  };
}
