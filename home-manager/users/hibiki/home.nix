{
  inputs,
  system,
  config,
  lib,
  username ? null,
  ...
}: {
  home = {
    # Only set username/homeDirectory for standalone home-manager
    # When used as NixOS module, these are set automatically
    username = lib.mkIf (username != null) username;
    homeDirectory = lib.mkIf (username != null) "/home/${username}";

    stateVersion = "25.11";

    packages = [
      inputs.nixvim.packages.${system}.default
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };

    sessionPath = [
      "$HOME/.bin"
    ];
  };

  imports = [
    ./pkgs.nix
  ];
}
