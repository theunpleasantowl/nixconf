{...}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

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
      -- Appearance
      -- ============================================================================
      config.color_scheme = "Tokyo Night Moon"
      config.font = wezterm.font("Terminess Nerd Font")
      config.font_size = 12
      config.window_background_opacity = 0.8

      -- ============================================================================
      -- Window Configuration
      -- ============================================================================
      config.hide_tab_bar_if_only_one_tab = true
      config.window_decorations = ""
      config.window_frame = {
        font = wezterm.font({ family = "Terminess Nerd Font", weight = "ExtraBold" }),
        font_size = 12,
      }
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
        -- Panes
        { key = "Return", mods = "ALT", action = act.DisableDefaultAssignment },
        { key = "\\", mods = "SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "|", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "[", mods = "SUPER", action = act.ActivatePaneDirection("Prev") },
        { key = "]", mods = "SUPER", action = act.ActivatePaneDirection("Next") },

        -- Movement
        { key = "l", mods = "SUPER", action = act.RotatePanes("Clockwise") },
        { key = "p", mods = "LEADER", action = act.PaneSelect },
        { key = "p", mods = "SUPER", action = act.PaneSelect },
        { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
        { key = "s", mods = "SUPER", action = act.PaneSelect({ mode = "SwapWithActive" }) },
        { key = "x", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },
        { key = "z", mods = "SUPER", action = act.TogglePaneZoomState },

        -- Font size adjustment
        { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
        { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
        { key = "0", mods = "CTRL", action = act.ResetFontSize },
      }

      -- ============================================================================
      -- Key Tables
      -- ============================================================================
      config.key_tables = {
        resize_pane = {
          { key = "Escape", action = "PopKeyTable" },
          { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
          { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
          { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
          { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
        },
      }

      -- ============================================================================
      -- Status Bar
      -- ============================================================================
      wezterm.on("update-right-status", function(window)
        local font_info = window:effective_config().font.font[1]
        local font_name = font_info.family
        local font_size = window:effective_config().font_size

        local status = wezterm.format({
          "ResetAttributes",
          { Background = { Color = "#666666" } },
          { Foreground = { Color = "White" } },
          { Text = string.format(" %s %spt  ", font_name, font_size) },
        })

        window:set_right_status(status)
      end)

      -- ============================================================================
      -- Tab Title Formatting
      -- ============================================================================
      wezterm.on("format-tab-title", function(tab)
        local zoom_icon = tab.active_pane.is_zoomed and "🔎 " or ""
        local tab_index = tab.tab_index + 1
        local title = tab.active_pane.title

        local bg_color = "#333333"
        local fg_color = tab.is_active and "#CCCCCC" or "#666666"
        local zoom_color = "Orange"

        local attrs = {
          { Background = { Color = bg_color } },
          { Foreground = { Color = fg_color } },
        }

        if tab.active_pane.is_zoomed then
          table.insert(attrs, { Foreground = { Color = zoom_color } })
        end

        table.insert(attrs, {
          Text = string.format("[%d] %s%s", tab_index, zoom_icon, title),
        })

        return attrs
      end)

      -- ============================================================================
      return config
    '';
  };
}
