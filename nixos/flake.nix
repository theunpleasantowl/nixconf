{
  description = "An example NixOS configuration";

  inputs = {
    nixpkgs = {url = "github:nixos/nixpkgs/nixos-unstable";};
    nur = {url = "github:nix-community/NUR";};
  };

  outputs = inputs:
  {
    nixosConfigurations = {
      giniro = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/giniro
        ];
        specialArgs = {inherit inputs;};
      };
      shirou = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/shirou
        ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}
