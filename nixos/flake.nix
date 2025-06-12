{
  description = "NixOS and Darwin Configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: let
    makeConfig = name: modules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = modules;
      };

    sharedModules = [
      ./modules/common.nix
      ./modules/ui
    ];
  in {
    nixosConfigurations = {
      giniro = makeConfig "giniro" (sharedModules ++ [./hosts/giniro]);
      shirou = makeConfig "shirou" (sharedModules ++ [./hosts/shirou]);
    };

    darwinConfigurations = {
      eva = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/eva

          inputs.home-manager.darwinModules.home-manager
        ];
      };
    };
  };
}
