{pkgs, ...}: {
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    autoEnable = true;
    enable = true;
  };
}
