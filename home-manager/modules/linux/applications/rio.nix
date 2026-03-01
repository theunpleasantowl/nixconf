{
  config,
  lib,
  ...
}:
let
  inherit (lib) optionalAttrs;
in
{
  programs.rio = {
    enable = true;

    settings = {
      # ============================================================================
      # General Configuration
      # ============================================================================
      renderer = {
        backend = "Automatic"; # WebGPU equivalent
        performance = "High";
      };

      # ============================================================================
      # Appearance (ONLY if Stylix is disabled)
      # ============================================================================
      fonts = lib.mkMerge [
        (optionalAttrs (!config.stylix.enable) {
          family = "Terminess Nerd Font";
          size = 12;
        })
      ];

      colors = lib.mkMerge [
        (optionalAttrs (!config.stylix.enable) {
          # Tokyo Night Moon
          background = "#222436";
          foreground = "#c8d3f5";
          cursor = "#c8d3f5";
          selection-background = "#2d3f76";
          selection-foreground = "#c8d3f5";

          # Normal colors
          black = "#1b1d2b";
          red = "#ff757f";
          green = "#c3e88d";
          yellow = "#ffc777";
          blue = "#82aaff";
          magenta = "#c099ff";
          cyan = "#86e1fc";
          white = "#828bb8";

          # Bright colors
          light-black = "#444a73";
          light-red = "#ff757f";
          light-green = "#c3e88d";
          light-yellow = "#ffc777";
          light-blue = "#82aaff";
          light-magenta = "#c099ff";
          light-cyan = "#86e1fc";
          light-white = "#c8d3f5";
        })
      ];

      window = lib.mkMerge [
        (optionalAttrs (!config.stylix.enable) {
          opacity = 0.8;
          decorations = "Disabled"; # NONE equivalent
          padding-x = 0;
          padding-y = [
            0
            0
          ];
        })
      ];

      # ============================================================================
      # Navigation (Tab Bar)
      # ============================================================================
      navigation = {
        mode = "Plain"; # Hides tab bar (closest to hide_tab_bar_if_only_one_tab)
        hide-if-single = true;
      };

      # ============================================================================
      # Cursor
      # ============================================================================
      cursor = {
        shape = "Block";
        blinking = false;
      };

      # ============================================================================
      # Key Bindings
      # ============================================================================
      # Note: Rio does not have a leader key — CTRL+O bindings are omitted.
      # SUPER+\ and SUPER+| use Rio's split actions.
      keyboard = {
        bindings = [
          # Splits
          {
            key = "Backslash";
            "with" = "Super";
            action = "SplitDown"; # vertical divider → panes side by side
          }
          {
            key = "Pipe";
            "with" = "Super";
            action = "SplitRight"; # horizontal divider → panes top/bottom
          }

          # Zoom / focus
          {
            key = "z";
            "with" = "Super";
            action = "ToggleViMode"; # closest approximation to pane zoom
          }

          # Font size
          {
            key = "=";
            "with" = "Control";
            action = "IncreaseFontSize";
          }
          {
            key = "Minus";
            "with" = "Control";
            action = "DecreaseFontSize";
          }
          {
            key = "0";
            "with" = "Control";
            action = "ResetFontSize";
          }
        ];
      };
    };
  };
}
