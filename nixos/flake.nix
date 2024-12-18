{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs = {url = "github:nixos/nixpkgs/nixos-unstable";};
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: {
    nixosConfigurations = {
      giniro = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/giniro
          ./modules/gnome.nix
          ./modules/hyprland.nix
          {
            environment.systemPackages = [
              inputs.home-manager.packages.x86_64-linux.default
            ];
          }
        ];
      };
      shirou = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/shirou
          ./modules/gnome.nix
          ./modules/hyprland.nix
          {
            environment.systemPackages = [
              inputs.home-manager.packages.x86_64-linux.default
            ];
          }
        ];
      };
    };
  };
}
