{
  isStandalone ? true,
  lib,
  pkgs,
  ...
}:
{
  stylix = {
    targets.wayprompt.enable = false;
  } // lib.optionalAttrs isStandalone {
    enable = lib.mkDefault true;
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/katy.yaml";
    polarity = lib.mkDefault "dark";
  };
}
