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
  };
  outputs =
    {
      self,
      nixpkgs,
      darwin,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib.extend (
        final: prev: {
          nixconf = import ./lib { lib = final; };
        }
      );

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
            nix.settings = {
              extra-substituters = [
                "https://walker.cachix.org"
                "https://walker-git.cachix.org"
              ];
              extra-trusted-public-keys = [
                "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
                "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
              ];
            };
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
            extraSpecialArgs = { inherit inputs system username; };
            modules = [
              inputs.stylix.homeModules.stylix
              inputs.sops-nix.homeModules.sops
              ./home-manager/users/hibiki
            ];
          };
      };
    };
}
