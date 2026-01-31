{
  inputs,
  system,
  config,
  ...
}:
let
  # Extend nixvim with Stylix theming
  nixvim-package = inputs.nixvim.packages.${system}.default;
  styled-nixvim = nixvim-package.extend config.stylix.targets.nixvim.exportedModule;
in
{
  # Enable Stylix nixvim target
  stylix.targets.nixvim = {
    enable = true;

    transparentBackground = {
      main = true;
      numberLine = true;
      signColumn = true;
    };
  };

  # Add styled nixvim to packages
  home.packages = [
    styled-nixvim
  ];
}
