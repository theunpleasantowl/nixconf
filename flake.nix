{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:theunpleasantowl/nixvim";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    makeConfig = name: modules:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = modules;
        specialArgs = {
          flakeRoot = self;
          inherit inputs system;
        };
      };

    sharedModules = [
      ./modules/common.nix
      ./modules/xdg
      ./users-hibiki.nix

      inputs.home-manager.nixosModules.home-manager

      {
        nix.settings = {
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          substituters = [
            "https://hyprland.cachix.org"
          ];
          trusted-substituters = [
            "https://hyprland.cachix.org"
          ];
          trusted-public-keys = [
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          ];
        };
      }
    ];
  in {
    # ---------------------------------------------------------
    # NixOS SYSTEMS
    # ---------------------------------------------------------
    nixosConfigurations = {
      neptune = makeConfig "neptune" (
        sharedModules
        ++ [
          ./hosts/neptune
          ./modules/ssh.nix
          ./modules/steam.nix
          ./modules/sunshine.nix
          ./modules/wine.nix
          ./modules/xdg/gnome_rdp.nix
        ]
      );

      giniro = makeConfig "giniro" (
        sharedModules
        ++ [
          ./hosts/giniro
          ./modules/ssh.nix
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

    # ---------------------------------------------------------
    # HOME-MANAGER SYSTEMS
    # ---------------------------------------------------------
    homeConfigurations = {
      hibiki = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        extraSpecialArgs = {inherit inputs system;};

        modules = [
          (import ./home/home.nix {
            home = {
              username = "hibiki";
              homeDirectory = "/home/hibiki";
              stateVersion = "25.11";
              packages = [
                inputs.nixvim.packages.${system}.default
              ];
            };
          })
          ./home/pkgs.nix
        ];
      };

      icarus = let
        darwinSystem = "aarch64-darwin";
      in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {system = darwinSystem;};

          extraSpecialArgs = {inherit inputs darwinSystem;};

          modules = [
            {
              home = {
                username = "icarus";
                homeDirectory = "/Users/icarus";
                stateVersion = "25.11";

                packages = [
                  inputs.nixvim.packages.${darwinSystem}.default
                ];
              };
            }
            ./home/modules/shell
          ];
        };
    };
  };
}
