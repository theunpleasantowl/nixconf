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
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:theunpleasantowl/nixvim";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, ... }@inputs:
    let
      confLib = import ./lib { inherit inputs; };
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

      packages.${confLib.systemLinux} = {
        newbee-ocr = import ./packages/newbee-ocr-nix {
          pkgs = import inputs.nixpkgs { system = confLib.systemLinux; };
        };
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
