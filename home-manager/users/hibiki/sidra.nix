{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  colors = config.lib.stylix.colors or { };
in
{
  programs.sidra = {
    enable = true;
    package = inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      storefront = "us";
      closeToTray.enabled = true;
      discord.enabled = true;
      musicService = "music";
      notifications.enabled = false;
      language = "en-US";
      theme = "custom";
      startPage = "new";
    };
    customTheme.dark = {
      accent = "#${colors.base0D}";
      accentHover = "#${colors.base0E}";
      base = "#${colors.base00}";
      crust = "#${colors.base02}";
      mantle = "#${colors.base01}";
      overlay = "#${colors.base03}";
      subtext0 = "#${colors.base03}";
      subtext1 = "#${colors.base04}";
      surface0 = "#${colors.base02}";
      surface1 = "#${colors.base03}";
      surface2 = "#${colors.base04}";
      text = "#${colors.base05}";
    };
  };
}
