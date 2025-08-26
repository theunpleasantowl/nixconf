{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:theunpleasantowl/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Helper to generate nixosConfigurations
    makeConfig = name: modules:
      inputs.nixpkgs.lib.nixosSystem {
        system = system;
        modules = modules;
        specialArgs = {
          flakeRoot = self;
        };
      };
    sharedModules = [
      ./modules/common.nix
      ./modules/ui
      ./users-hibiki.nix
      inputs.home-manager.nixosModules.home-manager
      {
        nix.settings = {
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
      }
    ];
  in {
    nixosConfigurations = {
      neptune = makeConfig "neptune" (
        sharedModules
        ++ [
          ./hosts/neptune
          ./modules/steam.nix
          ./modules/wine.nix
        ]
      );
      giniro = makeConfig "giniro" (
        sharedModules
        ++ [
          ./hosts/giniro
          ./modules/steam.nix
          ./modules/wine.nix
        ]
      );
      shirou = makeConfig "shirou" (
        sharedModules
        ++ [
          ./hosts/shirou
          ./modules/steam.nix
          ./modules/wine.nix
        ]
      );
    };

    homeConfigurations = {
      "hibiki" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        extraSpecialArgs = {
          inherit inputs system;
        };

        modules = [
          (import ./home/home.nix {
            home = {
              username = "hibiki";
              homeDirectory = "/home/hibiki";
              stateVersion = "25.05";
              packages = [
                inputs.nixvim.packages.${system}.default
              ];
            };
          })
          ./home/pkgs.nix
        ];
      };
      "icarus" = let
        darwinSystem = "aarch64-darwin";
      in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {system = darwinSystem;};
          modules = [
            {
              home = {
                username = "icarus";
                homeDirectory = "/Users/icarus";
                home.stateVersion = "25.05";
                home.packages = [
                  inputs.nixvim.packages.${system}.default
                ];
              };
            }
            ./home/modules/shell
          ];
        };
    };
  };
}
