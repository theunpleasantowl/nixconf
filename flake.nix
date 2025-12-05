{
  description = "NixOS Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };
  outputs = {
    self,
    nixpkgs,
    darwin,
    ...
  } @ inputs: let
    systemLinux = "x86_64-linux";
    systemDarwin = "aarch64-darwin";

    makeLinux = name: modules:
      nixpkgs.lib.nixosSystem {
        system = systemLinux;
        modules = modules;
        specialArgs = {
          inherit inputs;
          system = systemLinux;
        };
      };

    makeDarwin = name: modules:
      darwin.lib.darwinSystem {
        system = systemDarwin;
        modules = modules;
        specialArgs = {
          inherit inputs;
          system = systemDarwin;
        };
      };

    sharedModules = [
      ./users/users-hibiki.nix
      inputs.home-manager.nixosModules.home-manager
    ];

    linuxModules = [
      ./modules/shared/common.nix
      ./modules/linux/boot-splash.nix
      ./modules/linux/xdg
    ];

    darwinModules = [
      # TBD
    ];
  in {
    nixosConfigurations = {
      neptune = makeLinux "neptune" (
        sharedModules
        ++ linuxModules
        ++ [
          ./hosts/neptune
          ./modules/linux/steam.nix
          ./modules/linux/sunshine.nix
          ./modules/linux/wine.nix
          ./modules/linux/xdg/gnome_rdp.nix
          ./modules/shared/ssh.nix
        ]
      );
      giniro = makeLinux "giniro" (
        sharedModules
        ++ linuxModules
        ++ [
          ./hosts/giniro
          ./modules/linux/steam.nix
          ./modules/linux/wine.nix
          ./modules/shared/ssh.nix
        ]
      );
      shirou = makeLinux "shirou" (
        sharedModules
        ++ linuxModules
        ++ [
          ./hosts/shirou
          ./modules/linux/steam.nix
          ./modules/linux/wine.nix
        ]
      );
    };
    # ---------------------------------------------------------
    # HOME-MANAGER
    # ---------------------------------------------------------
    homeConfigurations = {
      hibiki = let
        username = "hibiki";
        system = systemLinux;
      in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {inherit system;};
          extraSpecialArgs = {inherit inputs system username;};
          modules = [
            ./home-manager/users/hibiki
          ];
        };
      icarus = let
        username = "icarus";
        system = systemDarwin;
      in
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {inherit system;};
          extraSpecialArgs = {inherit inputs system username;};
          modules = [
            ./home-manager/users/icarus
          ];
        };
    };
  };
}
