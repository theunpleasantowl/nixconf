{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:theunpleasantowl/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:theunpleasantowl/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sidra = {
      url = "github:wimpysworld/sidra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-craftapps = {
      url = "github:olafkfreund/nix-craftapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, ... }@inputs:
    let
      confLib = import ./lib { inherit inputs; };
      unstableInputs = inputs // {
        nixpkgs = inputs.nixpkgs-unstable;
      };
      linuxHostNames = [
        "neptune"
        "wsl"
        "qemu"
        "giniro"
        "shirou"
      ];
    in
    {
      nixosConfigurations = confLib.makeLinuxHosts {
        names = linuxHostNames;
      };

      # Use `.#nixosConfigurationsUnstable.<host>` to build or switch a host
      # entirely on nixos-unstable. Normal configurations remain on 26.11.
      nixosConfigurationsUnstable = confLib.makeLinuxHosts {
        names = linuxHostNames;
        flakeInputs = unstableInputs;
      };

      checks.${confLib.systemLinux} =
        builtins.mapAttrs (_: host: host.config.system.build.toplevel) self.nixosConfigurations
        // builtins.listToAttrs (
          map (hostName: {
            name = "home-hibiki-${hostName}";
            value = self.homeConfigurations."hibiki@${hostName}".activationPackage;
          }) linuxHostNames
        );

      checks.${confLib.systemDarwin}.home-icarus = self.homeConfigurations.icarus.activationPackage;

      packages.${confLib.systemLinux} = {
        wsl = self.nixosConfigurations.wsl.config.system.build.tarballBuilder;
      };

      apps.${confLib.systemLinux} = {
        qemu = {
          type = "app";
          program = "${self.nixosConfigurations.qemu.config.system.build.vm}/bin/run-qemu-vm";
        };
      };
      # ---------------------------------------------------------
      # HOME-MANAGER
      # ---------------------------------------------------------
      homeConfigurations =
        builtins.listToAttrs (
          map (hostName: {
            name = "hibiki@${hostName}";
            value = confLib.makeHome {
              username = "hibiki";
              system = confLib.systemLinux;
              osConfig = self.nixosConfigurations.${hostName}.config;
            };
          }) linuxHostNames
        )
        // {
          icarus = confLib.makeHome {
            username = "icarus";
            system = confLib.systemDarwin;
          };
        };
    };
}
