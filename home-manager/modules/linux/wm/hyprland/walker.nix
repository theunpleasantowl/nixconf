{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Check if Stylix is enabled
  useStylix = config.lib.stylix.enable or false;

  # Only define colors/font if Stylix is enabled
  stylixColors = if useStylix then config.lib.stylix.colors else null;
  stylixFont = if useStylix then config.stylix.fonts.monospace.name else null;

  # Helper to generate rgba() string from Stylix color
  rgba = color: alpha: "rgba(${color}-rgb-r, ${color}-rgb-g, ${color}-rgb-b, ${toString alpha})";
in
{
  # Hyprland-only Walker service
  systemd.user.services.walker = {
    Unit = {
      ConditionEnvironment = lib.mkForce "XDG_CURRENT_DESKTOP=Hyprland";
    };
  };

  services.walker = {
    #enable = true;

    settings = {
      theme = lib.mkForce (if useStylix then "stylix" else "default");

      search = {
        delay = 0;
        placeholder = "Search...";
      };

      # ... rest of your settings ...
    };

    theme =
      if useStylix then
        {
          stylix = {
            style = ''
              * {
                all: unset;
                font-family: "${stylixFont}", monospace;
                font-size: 14px;
                color: #${stylixColors.base05};
              }

              #window {
                background: ${rgba stylixColors.base00 0.95};
                border-radius: 12px;
                border: 2px solid #${stylixColors.base0D};
                padding: 20px;
              }

              #search {
                background: ${rgba stylixColors.base01 0.7};
                border: 1px solid #${stylixColors.base03};
                border-radius: 8px;
                padding: 12px 16px;
                caret-color: #${stylixColors.base0D};
                margin-bottom: 12px;
              }

              #search:focus {
                border-color: #${stylixColors.base0D};
                background: ${rgba stylixColors.base01 0.9};
              }

              #typeahead { color: #${stylixColors.base03}; font-style: italic; }
              #list { background: transparent; margin-top: 8px; }
              #element {
                padding: 10px 12px;
                margin: 2px 0;
                border-radius: 6px;
                background: transparent;
              }

              #element:hover { background: ${rgba stylixColors.base02 0.8}; }
              #element:selected {
                background: ${rgba stylixColors.base0D 0.25};
                border-left: 3px solid #${stylixColors.base0D};
                padding-left: 9px;
              }

              #prefix { color: #${stylixColors.base0D}; font-weight: bold; margin-right: 8px; font-size: 12px; }
              #text { color: #${stylixColors.base05}; }
              #sub { color: #${stylixColors.base03}; font-size: 12px; margin-left: 8px; }
              #icon { margin-right: 12px; min-width: 32px; min-height: 32px; }

              #activation {
                color: #${stylixColors.base0A};
                font-weight: bold;
                background: ${rgba stylixColors.base0A 0.15};
                border-radius: 4px;
                padding: 2px 6px;
                font-size: 11px;
                margin-right: 12px;
              }

              #spinner { color: #${stylixColors.base0D}; }

              scrollbar { background: transparent; width: 8px; }
              scrollbar slider {
                background: ${rgba stylixColors.base0D 0.3};
                border-radius: 8px;
                min-height: 40px;
              }
              scrollbar slider:hover { background: ${rgba stylixColors.base0D 0.5}; }

              #item.calc       { color: #${stylixColors.base0B}; }
              #item.websearch  { color: #${stylixColors.base0C}; }
              #item.clipboard  { color: #${stylixColors.base0E}; }
              #item.symbols    { color: #${stylixColors.base0A}; }
              #item.finder     { color: #${stylixColors.base09}; }

              #placeholder { color: #${stylixColors.base03}; font-style: italic; }
            '';
          };
        }
      else
        { };
  };
}
