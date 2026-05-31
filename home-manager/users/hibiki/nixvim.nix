{
  inputs,
  system,
  config,
  lib,
  pkgs,
  ...
}:
let
  # Extend nixvim with Stylix theming
  nixvim-package = inputs.nixvim.packages.${system}.default;
  hasStylixNixvim = pkgs.stdenv.isLinux;
  selectedNixvim =
    if hasStylixNixvim then
      nixvim-package.extend config.stylix.targets.nixvim.exportedModule
    else
      nixvim-package;
in
{
  # Enable Stylix nixvim target
  stylix.targets.nixvim = lib.mkIf hasStylixNixvim {
    enable = true;

    transparentBackground = {
      main = true;
      numberLine = true;
      signColumn = true;
    };
  };

  # Add styled nixvim to packages
  home.packages = [
    selectedNixvim
  ];
}
