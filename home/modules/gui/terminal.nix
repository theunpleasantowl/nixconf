{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()
      config.font_size = 15.0
      config.font = wezterm.font "Terminess Nerd Font"
      config.window_background_opacity = 1
      config.window_decorations = 'RESIZE'
      config.audible_bell = "Disabled"

      return config
    '';
  };
}
