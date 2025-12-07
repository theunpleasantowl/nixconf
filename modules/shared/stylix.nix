{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/spaceduck.yaml";

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
