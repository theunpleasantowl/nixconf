{
  description = "An example NixOS configuration";

  inputs = {
    nixpkgs = {url = "github:nixos/nixpkgs/nixos-unstable";};
    nur = {url = "github:nix-community/NUR";};
    home-manager = {url = "github:nix-community/home-manager";};
  };

  outputs = inputs: {
    nixosConfigurations = {
      giniro = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/giniro
          ./modules/gnome.nix
          ./modules/hyprland.nix
        ];
        specialArgs = {inherit inputs;};
      };
      shirou = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/shirou
          ./modules/gnome.nix
          ./modules/hyprland.nix
        ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}
