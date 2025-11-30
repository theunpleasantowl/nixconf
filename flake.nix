{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:theunpleasantowl/nixvim";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "hibiki";

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
      ./modules/boot-splash.nix
      ./modules/common.nix
      ./modules/xdg
      ./users/users-hibiki.nix

      inputs.home-manager.nixosModules.home-manager
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
        extraSpecialArgs = {inherit inputs system username;};

        modules = [
          (import ./home-manager/users/hibiki)
        ];
      };

      icarus = let
        darwinSystem = "aarch64-darwin";
        darwinUsername = "icarus";
      in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {system = darwinSystem;};
          modules = [
            {
              home = {
                username = username;
                homeDirectory = "/Users/${darwinUsername}";
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
