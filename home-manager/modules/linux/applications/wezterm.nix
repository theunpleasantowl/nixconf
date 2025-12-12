{
  pkgs,
  config,
  ...
}: {
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    extraConfig = ''
      local wezterm = require("wezterm")
      local selector = require("config-selector")
      local act = wezterm.action
      local config = wezterm.config_builder()

      -- ============================================================================
      -- Configuration Selectors
      -- ============================================================================
      local selectors = {
        fonts = selector.new({ title = "Font Selector", subdir = "fonts" }),
        inactive = selector.new({ title = "Inactive Pane Selector", subdir = "inactivepanes" }),
        leading = selector.new({ title = "Font Leading Selector", subdir = "leadings" }),
        opacity = selector.new({ title = "Opacity Selector", subdir = "opacity" }),
        schemes = selector.new({ title = "Color Scheme Selector", subdir = "colorschemes" }),
        sizes = selector.new({ title = "Font Size Selector", subdir = "sizes" }),
      }

      -- ============================================================================
      -- Default Values
      -- ============================================================================
      selectors.fonts:select(config, "Terminess Nerd Font")
      selectors.schemes:select(config, "Tokyo Night Moon")
      selectors.opacity:select(config, "80%")

      -- ============================================================================
      -- General Configuration
      -- ============================================================================
      config.front_end = "WebGpu"
      config.force_reverse_video_cursor = true
      config.use_resize_increments = false
      config.adjust_window_size_when_changing_font_size = false

      -- ============================================================================
      -- Window Configuration
      -- ============================================================================
      config.hide_tab_bar_if_only_one_tab = true
      config.window_decorations = "RESIZE"
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
      local function create_keybinds()
        local pane_binds = {
          { key = "Return", mods = "ALT", action = act.DisableDefaultAssignment },
          { key = "\\", mods = "SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
          { key = "|", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
          { key = "[", mods = "SUPER", action = act.ActivatePaneDirection("Prev") },
          { key = "]", mods = "SUPER", action = act.ActivatePaneDirection("Next") },
        }

        local movement_binds = {
          { key = "l", mods = "SUPER", action = act.RotatePanes("Clockwise") },
          { key = "p", mods = "LEADER", action = act.PaneSelect },
          { key = "p", mods = "SUPER", action = act.PaneSelect },
          { key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
          { key = "s", mods = "SUPER", action = act.PaneSelect({ mode = "SwapWithActive" }) },
          { key = "x", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActive" }) },
          { key = "z", mods = "SUPER", action = act.TogglePaneZoomState },
        }

        local selector_binds = {
          { key = "f", mods = "LEADER", action = selectors.fonts:selector_action() },
          { key = "i", mods = "LEADER", action = selectors.inactive:selector_action() },
          { key = "l", mods = "LEADER", action = selectors.leading:selector_action() },
          { key = "o", mods = "LEADER", action = selectors.opacity:selector_action() },
          { key = "c", mods = "LEADER", action = selectors.schemes:selector_action() },
          { key = "s", mods = "LEADER", action = selectors.sizes:selector_action() },
        }

        local binds = {}
        for _, bind in ipairs(pane_binds) do
          table.insert(binds, bind)
        end
        for _, bind in ipairs(movement_binds) do
          table.insert(binds, bind)
        end
        for _, bind in ipairs(selector_binds) do
          table.insert(binds, bind)
        end

        return binds
      end

      config.keys = create_keybinds()

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

  # Copy all wezterm config files from your dotfiles
  home.file = {
    # Main config
    ".config/wezterm/config-selector.lua".source = ./wezterm-config/config-selector.lua;

    # Fonts
    ".config/wezterm/fonts/bigblue.lua".source = ./wezterm-config/fonts/bigblue.lua;
    ".config/wezterm/fonts/blex.lua".source = ./wezterm-config/fonts/blex.lua;
    ".config/wezterm/fonts/firacode.lua".source = ./wezterm-config/fonts/firacode.lua;
    ".config/wezterm/fonts/gohufont.lua".source = ./wezterm-config/fonts/gohufont.lua;
    ".config/wezterm/fonts/heavydata.lua".source = ./wezterm-config/fonts/heavydata.lua;
    ".config/wezterm/fonts/sauce-code-pro.lua".source = ./wezterm-config/fonts/sauce-code-pro.lua;
    ".config/wezterm/fonts/terminess.lua".source = ./wezterm-config/fonts/terminess.lua;

    # Inactive panes
    ".config/wezterm/inactivepanes/variants.lua".source = ./wezterm-config/inactivepanes/variants.lua;

    # Leadings
    ".config/wezterm/leadings/leadings.lua".source = ./wezterm-config/leadings/leadings.lua;

    # Opacity
    ".config/wezterm/opacity/opacity.lua".source = ./wezterm-config/opacity/opacity.lua;

    # Sizes
    ".config/wezterm/sizes/sizes.lua".source = ./wezterm-config/sizes/sizes.lua;
  };
}
