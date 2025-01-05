{
  description = "Meta-flake for NixOS and Home Manager configurations";

  inputs = {
  };

  outputs = {...}: let
    nixos-flake = builtins.getFlake ./nixos;
    home-manager-flake = builtins.getFlake ./home;
  in {
    # NixOS configurations
    nixosConfigurations = nixos-flake.outputs.nixosConfigurations;

    # Home Manager configurations
    homeManagerConfigurations = home-manager-flake.outputs.homeManagerConfigurations;
  };
}
