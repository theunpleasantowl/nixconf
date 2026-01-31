{
  pkgs,
  lib,
  ...
}:
{
  # https://tinted-theming.github.io/tinted-gallery/
  stylix = {
    enable = lib.mkDefault false;
    autoEnable = true;

    targets = {
      plymouth.enable = false;
      qt.enable = false; # Breaks many apps
    };

    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/katy.yaml";

    fonts = {
      serif = {
        package = pkgs.libre-baskerville;
        name = "Libre Baskerville";
      };
      sansSerif = {
        package = pkgs.lato;
        name = "Lato";
      };
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 0.7;
      popups = 0.5;
      terminal = 1.0;
    };
  };
}
