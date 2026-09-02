{
  isStandalone ? true,
  lib,
  pkgs,
  ...
}:
{
  stylix = lib.mkIf isStandalone {
    enable = lib.mkDefault true;
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/katy.yaml";
    polarity = lib.mkDefault "dark";
  };
}
