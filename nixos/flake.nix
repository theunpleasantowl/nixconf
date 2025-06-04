{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
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
      ({
        config,
        pkgs,
        ...
      }: {
        nix.settings = {
          auto-optimise-store = true;
          experimental-features = ["nix-command" "flakes"];
        };
      })
    ];
  in {
    nixosConfigurations = {
      neptune = makeConfig "neptune" (sharedModules
        ++ [
          ./hosts/neptune
          ./modules/steam.nix
          ./modules/wine.nix
        ]);
      giniro = makeConfig "giniro" (sharedModules
        ++ [
          ./hosts/giniro
          ./modules/steam.nix
          ./modules/wine.nix
        ]);
      shirou = makeConfig "shirou" (sharedModules
        ++ [
          ./hosts/shirou
          inputs.sops-nix.nixosModules.sops
          ./modules/steam.nix
          ./modules/wine.nix
        ]);
    };
  };
}
