{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    # Helper to generate nixosConfigurations
    makeConfig = name: modules:
      inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = modules;
      };
    sharedModules = [
      ./modules/common.nix
      ./modules/ui
    ];
  in {
    nixosConfigurations = {
      giniro = makeConfig "giniro" (sharedModules
        ++ [
          ./hosts/giniro
        ]);
      shirou = makeConfig "shirou" (sharedModules
        ++ [
          ./hosts/shirou
        ]);
    };
  };
}
