{
  inputs,
  system,
  lib,
  username ? null,
  ...
}: {
  home = {
    # Set username/homeDirectory for standalone home-manager
    # When used as NixOS module, we must not set these.
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
