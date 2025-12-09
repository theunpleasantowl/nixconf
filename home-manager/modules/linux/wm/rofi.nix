{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.wezterm}/bin/wezterm";

    extraConfig = {
      modi = "drun,run,window,ssh";
      show-icons = true;
      icon-theme = config.gtk.iconTheme.name;
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Windows";
      display-ssh = " SSH";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";

      # Performance
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";

      # Behavior
      click-to-exit = true;
      disable-history = false;
      hide-scrollbar = true;
    };

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in
      lib.mkDefault {
        "*" = {
          bg0 = mkLiteral "#1e1e2e";
          bg1 = mkLiteral "#181825";
          bg2 = mkLiteral "#313244";
          bg3 = mkLiteral "#45475a";
          fg0 = mkLiteral "#cdd6f4";
          fg1 = mkLiteral "#bac2de";
          fg2 = mkLiteral "#a6adc8";
          red = mkLiteral "#f38ba8";
          green = mkLiteral "#a6e3a1";
          yellow = mkLiteral "#f9e2af";
          blue = mkLiteral "#89b4fa";
          magenta = mkLiteral "#cba6f7";
          cyan = mkLiteral "#89dceb";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg0";

          margin = 0;
          padding = 0;
          spacing = 0;
        };

        window = {
          location = mkLiteral "center";
          width = 640;
          background-color = mkLiteral "@bg0";
          border = mkLiteral "2px";
          border-color = mkLiteral "@blue";
          border-radius = mkLiteral "12px";
        };

        inputbar = {
          padding = mkLiteral "12px";
          spacing = mkLiteral "12px";
          children = map mkLiteral [
            "icon-search"
            "entry"
          ];
          background-color = mkLiteral "@bg1";
        };

        icon-search = {
          expand = false;
          filename = "search";
          size = mkLiteral "28px";
        };

        entry = {
          placeholder = "Search";
          placeholder-color = mkLiteral "@fg2";
        };

        message = {
          margin = mkLiteral "12px 0 0";
          border-radius = mkLiteral "8px";
          border-color = mkLiteral "@bg2";
          background-color = mkLiteral "@bg2";
        };

        textbox = {
          padding = mkLiteral "8px 24px";
        };

        listview = {
          lines = 10;
          columns = 1;
          fixed-height = false;
          border = mkLiteral "1px 0 0";
          border-color = mkLiteral "@bg2";
          spacing = mkLiteral "4px";
          scrollbar = false;
          padding = mkLiteral "8px 0";
        };

        element = {
          padding = mkLiteral "8px 16px";
          spacing = mkLiteral "16px";
          border-radius = mkLiteral "8px";
        };

        "element normal active" = {
          text-color = mkLiteral "@blue";
        };

        "element selected normal" = {
          background-color = mkLiteral "@bg2";
        };

        "element selected active" = {
          background-color = mkLiteral "@bg2";
          text-color = mkLiteral "@blue";
        };

        element-icon = {
          size = mkLiteral "32px";
          vertical-align = mkLiteral "0.5";
        };

        element-text = {
          text-color = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
        };
      };
  };
}
