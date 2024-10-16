{
  # Import Kitty and WezTerm modules
  # Kitty configuration
  #  programs.kitty = {
  #    enable = true;
  #    extraConfig = ''
  #      background_opacity 0.9
  #      cursor_shape block
  #      allow_remote_control no
  #      map ctrl+shift+t new_tab
  #      map ctrl+shift+w close_tab
  #    '';
  #  };

  # WezTerm configuration
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      enable_tab_bar = false
      window_background_opacity = 0.85
      default_prog = { "/bin/zsh", "-l" }
    '';
  };
}
