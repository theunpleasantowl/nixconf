{
  description = "A flake for home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/NUR";
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
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    stateVersion = "24.11";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      nurPkgs = inputs.nur.legacyPackages."x86_64-linux";
    };

    homeDirPrefix =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Users"
      else "/home";

    username = "hibiki";

    homeDirectory = "${homeDirPrefix}/${username}";

    home = import ./home.nix {
      inherit homeDirectory pkgs stateVersion system username;
    };
  in {
    packages.${system}.default = home-manager.defaultPackage.${system};

    home-manager.extraSpecialArgs = {inherit inputs;};
    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        home
        ./pkgs.nix
        {
          home.packages = [
            inputs.nixvim.packages.${system}.default
          ];
        }
      ];
    };
  };
}
