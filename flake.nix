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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:theunpleasantowl/nixvim";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      darwin,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;

      systemLinux = "x86_64-linux";
      systemDarwin = "aarch64-darwin";

      makeLinux =
        name: modules:
        lib.nixosSystem {
          system = systemLinux;
          modules = modules;
          specialArgs = {
            inherit inputs;
            system = systemLinux;
          };
        };

      makeDarwin =
        name: modules:
        darwin.lib.darwinSystem {
          system = systemDarwin;
          modules = modules;
          specialArgs = {
            inherit inputs;
            system = systemDarwin;
          };
        };

      sharedModules = [
        ./modules/shared/common.nix
        ./modules/shared/security.nix
        ./modules/shared/stylix.nix
        ./users/users-hibiki.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        inputs.stylix.nixosModules.stylix
        inputs.niri.nixosModules.niri
      ];

      linuxModules = [
        ./modules/linux
        ./modules/linux/xdg
      ];

      darwinModules = [
        # TBD
      ];
    in
    {
      nixosConfigurations = {
        neptune = makeLinux "neptune" (
          sharedModules
          ++ linuxModules
          ++ [
            ./hosts/neptune
          ]
        );
        giniro = makeLinux "giniro" (
          sharedModules
          ++ linuxModules
          ++ [
            ./hosts/giniro
          ]
        );
        shirou = makeLinux "shirou" (
          sharedModules
          ++ linuxModules
          ++ [
            ./hosts/shirou
          ]
        );
        wsl = makeLinux "wsl" (
          sharedModules
          ++ linuxModules
          ++ [
            ./hosts/wsl
          ]
        );
        qemu = makeLinux "qemu" (
          sharedModules
          ++ linuxModules
          ++ [
            ./hosts/qemu
          ]
        );
      };

      packages.${systemLinux} = {
        wsl = self.nixosConfigurations.wsl.config.system.build.tarballBuilder;
      };

      apps.${systemLinux} = {
        qemu = {
          type = "app";
          program = "${self.nixosConfigurations.qemu.config.system.build.vm}/bin/run-qemu-vm";
        };
      };
      # ---------------------------------------------------------
      # HOME-MANAGER
      # ---------------------------------------------------------
      homeConfigurations = {
        hibiki =
          let
            username = "hibiki";
            system = systemLinux;
          in
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs { inherit system; };
            extraSpecialArgs = {
              inherit inputs system username;
              isStandalone = true;
            };
            modules = [
              inputs.stylix.homeModules.stylix
              inputs.sops-nix.homeModules.sops
              inputs.niri.homeModules.niri
              ./home-manager/users/hibiki
            ];
          };
        icarus =
          let
            username = "icarus";
            system = systemDarwin;
          in
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs { inherit system; };
            extraSpecialArgs = {
              inherit inputs system username;
              isStandalone = true;
            };
            modules = [
              inputs.stylix.homeModules.stylix
              inputs.sops-nix.homeModules.sops
              ./home-manager/users/hibiki
            ];
          };
      };
    };
}
