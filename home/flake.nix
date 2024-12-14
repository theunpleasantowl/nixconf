{
  description = "A flake for home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      config.allowUnfree = true;
      system = "x86_64-linux";
    };
  in {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;

    home-manager.extraSpecialArgs = {inherit inputs;};
    homeConfigurations = {
      "hibiki" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./pkgs.nix
          {
            home.packages = [inputs.nixvim.packages.${system}.default];
          }
        ];
      };
    };
  };
}
