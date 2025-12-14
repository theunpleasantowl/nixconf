{
  pkgs,
  lib,
  ...
}: {
  stylix = {
    enable = true;
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
  };
}
