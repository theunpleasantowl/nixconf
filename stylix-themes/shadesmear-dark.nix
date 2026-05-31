{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/shadesmear-dark.yaml";
    polarity = "dark";
  };
}
