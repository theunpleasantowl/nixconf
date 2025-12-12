{
  pkgs,
  inputs,
  ...
}: {
  # Walker uses GTK4 and will automatically use your GTK icon theme
  # Make sure you have an icon theme configured in theme.nix

  imports = [inputs.walker.homeManagerModules.default];
  programs.walker = {
    enable = true;
    runAsService = true; # Run as background service for instant launch

    config = {
      # Search configuration
      search = {
        delay = 0;
        placeholder = "Search...";
      };

      # List appearance
      list = {
        height = 500;
        always_show = true;
        max_entries = 50;
      };

      # UI positioning
      ui = {
        fullscreen = false;
        anchors = {
          top = true;
        };
        window_margin = {
          top = 100;
        };
        width = 800;
      };

      # Placeholder texts
      placeholders = {
        "default" = {
          input = "Type to search...";
          list = "No results";
        };
      };

      # Module-specific prefixes
      providers = {
        prefixes = [
          {
            provider = "websearch";
            prefix = "+";
          }
          {
            provider = "calc";
            prefix = "=";
          }
          {
            provider = "finder";
            prefix = "/";
          }
          {
            provider = "clipboard";
            prefix = ":";
          }
          {
            provider = "symbols";
            prefix = ".";
          }
          {
            provider = "providerlist";
            prefix = ";";
          }
        ];
      };

      # Built-in modules configuration
      modules = {
        applications = {
          cache = true;
          show_icon = true;
          show_description = true;
          use_generic_name = false;
        };

        runner = {
          shell = "${pkgs.zsh}/bin/zsh";
          history = true;
        };

        websearch = {
          engines = [
            {
              name = "Google";
              url = "https://www.google.com/search?q=%s";
            }
            {
              name = "DuckDuckGo";
              url = "https://duckduckgo.com/?q=%s";
            }
            {
              name = "GitHub";
              url = "https://github.com/search?q=%s";
            }
            {
              name = "YouTube";
              url = "https://www.youtube.com/results?search_query=%s";
            }
            {
              name = "NixOS Packages";
              url = "https://search.nixos.org/packages?query=%s";
            }
            {
              name = "NixOS Options";
              url = "https://search.nixos.org/options?query=%s";
            }
          ];
        };

        clipboard = {
          max_entries = 100;
          image_height = 200;
        };

        finder = {
          path = "~";
          depth = 3;
        };
      };

      # Keybindings
      keybinds = {
        # Quick activation for first 10 results
        quick_activate = [
          "F1"
          "F2"
          "F3"
          "F4"
          "F5"
          "F6"
          "F7"
          "F8"
          "F9"
          "F10"
        ];

        # Navigation
        up = [
          "Up"
          "ctrl+k"
        ];
        down = [
          "Down"
          "ctrl+j"
        ];
        page_up = [
          "Page_Up"
          "ctrl+u"
        ];
        page_down = [
          "Page_Down"
          "ctrl+d"
        ];

        # Selection
        activate = [
          "Return"
          "ctrl+space"
        ];
        tab_activate = ["ctrl+Return"];

        # Close
        close = [
          "Escape"
          "ctrl+c"
        ];

        # History navigation
        history_previous = ["ctrl+p"];
        history_next = ["ctrl+n"];

        # Clear search
        clear = ["ctrl+l"];
      };
      theme = "catppuccin";
    };

    # Custom Catppuccin theme
    themes."catppuccin" = {
      style = ''
        * {
          all: unset;
          font-family: "FiraCode Nerd Font", monospace;
          font-size: 14px;
          color: #cdd6f4;
        }

        #window {
          background: rgba(30, 30, 46, 0.95);
          border-radius: 12px;
          border: 2px solid #89b4fa;
          padding: 20px;
        }

        #search {
          background: rgba(49, 50, 68, 0.6);
          border: 1px solid #45475a;
          border-radius: 8px;
          padding: 12px 16px;
          margin-bottom: 12px;
          caret-color: #89b4fa;
        }

        #search:focus {
          border-color: #89b4fa;
          outline: none;
          background: rgba(49, 50, 68, 0.8);
        }

        #typeahead {
          color: #6c7086;
          font-style: italic;
        }

        #list {
          background: transparent;
          border-radius: 8px;
          margin-top: 8px;
        }

        #element {
          padding: 10px 12px;
          margin: 2px 0;
          border-radius: 6px;
          background: transparent;
          transition: all 200ms ease;
        }

        #element:hover {
          background: rgba(49, 50, 68, 0.8);
        }

        #element:selected {
          background: rgba(137, 180, 250, 0.3);
          border-left: 3px solid #89b4fa;
          padding-left: 9px;
        }

        #element:selected:hover {
          background: rgba(137, 180, 250, 0.4);
        }

        #prefix {
          color: #89b4fa;
          font-weight: bold;
          margin-right: 8px;
          font-size: 12px;
        }

        #text {
          color: #cdd6f4;
        }

        #sub {
          color: #6c7086;
          font-size: 12px;
          margin-left: 8px;
        }

        #icon {
          margin-right: 12px;
          min-width: 32px;
          min-height: 32px;
        }

        #activation {
          color: #f9e2af;
          font-weight: bold;
          margin-right: 12px;
          background: rgba(249, 226, 175, 0.15);
          border-radius: 4px;
          padding: 2px 6px;
          font-size: 11px;
        }

        #spinner {
          color: #89b4fa;
        }

        scrollbar {
          background: transparent;
          width: 8px;
        }

        scrollbar slider {
          background: rgba(137, 180, 250, 0.3);
          border-radius: 8px;
          min-height: 40px;
        }

        scrollbar slider:hover {
          background: rgba(137, 180, 250, 0.5);
        }

        /* Module-specific styling */

        #item.calc {
          color: #a6e3a1;
        }

        #item.websearch {
          color: #89dceb;
        }

        #item.clipboard {
          color: #cba6f7;
        }

        #item.symbols {
          color: #f9e2af;
        }

        #item.finder {
          color: #fab387;
        }

        /* Placeholder styling */

        #placeholder {
          color: #6c7086;
          font-style: italic;
        }
      '';
    };
  };
}
