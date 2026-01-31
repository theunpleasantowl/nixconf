{
  config,
  lib,
  ...
}:
let
  inherit (lib) optionalString;
in
{
  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    extraConfig = ''
      local wezterm = require("wezterm")
      local act = wezterm.action
      local config = wezterm.config_builder()

      -- ============================================================================
      -- General Configuration
      -- ============================================================================
      config.front_end = "WebGpu"
      config.force_reverse_video_cursor = true
      config.use_resize_increments = false
      config.adjust_window_size_when_changing_font_size = false

      -- ============================================================================
      -- Appearance (ONLY if Stylix is disabled)
      -- ============================================================================
      ${optionalString (!config.stylix.enable) ''
        config.color_scheme = "Tokyo Night Moon"
        config.font = wezterm.font("Terminess Nerd Font")
        config.font_size = 12
      ''}
        config.window_background_opacity = 0.8

      -- ============================================================================
      -- Window Configuration
      -- ============================================================================
      config.hide_tab_bar_if_only_one_tab = true
      config.window_decorations = "NONE"
      config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }

      -- ============================================================================
      -- Mouse Bindings
      -- ============================================================================
      config.mouse_bindings = {
        {
          event = { Down = { streak = 3, button = "Left" } },
          action = act.SelectTextAtMouseCursor("SemanticZone"),
          mods = "NONE",
        },
      }

      -- ============================================================================
      -- Leader Key
      -- ============================================================================
      config.leader = { key = "o", mods = "CTRL", timeout_milliseconds = 1000 }

      -- ============================================================================
      -- Key Bindings
      -- ============================================================================
      config.keys = {
        { key = "\\", mods = "SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "|", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "z", mods = "SUPER", action = act.TogglePaneZoomState },

        { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
        { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
        { key = "0", mods = "CTRL", action = act.ResetFontSize },
      }

      -- ============================================================================
      return config
    '';
  };
}
