{
  inputs ? null,
  systems ? { },
}:
let
  defaultSystems = {
    linux = "x86_64-linux";
    darwin = "aarch64-darwin";
  };

  systemLinux = systems.linux or defaultSystems.linux;
  systemDarwin = systems.darwin or defaultSystems.darwin;

  importModuleSiblings =
    dir:
    with builtins;
    let
      entries = readDir dir;
      hasDefaultNix = name: pathExists (dir + "/${name}/default.nix");
      isImportable =
        name:
        name != "default.nix"
        && (
          (entries.${name} == "regular" && match ".*\\.nix$" name != null)
          || (entries.${name} == "directory" && hasDefaultNix name)
        );
    in
    map (name: dir + "/${name}") (filter isImportable (attrNames entries));

  importHostConfiguration = dir: {
    imports = [ (dir + "/configuration.nix") ];
  };

  sharedNixosModules = flakeInputs: [
    ../modules/common.nix
    ../users/users-hibiki.nix
    flakeInputs.home-manager.nixosModules.home-manager
    flakeInputs.sops-nix.nixosModules.sops
    flakeInputs.stylix.nixosModules.stylix
  ];

  linuxModules = [
    ../modules/linux
    ../modules/linux/xdg
  ];

  makeNixosSystem =
    {
      flakeInputs ? inputs,
      system ? systemLinux,
      modules,
    }:
    flakeInputs.nixpkgs.lib.nixosSystem {
      inherit system modules;
      specialArgs = {
        inputs = flakeInputs;
        inherit system;
      };
    };

  makeLinuxHost =
    {
      name,
      flakeInputs ? inputs,
      extraModules ? [ ],
    }:
    makeNixosSystem {
      inherit flakeInputs;
      system = systemLinux;
      modules =
        sharedNixosModules flakeInputs ++ linuxModules ++ [ (../hosts + "/${name}") ] ++ extraModules;
    };

  makeLinuxHosts =
    {
      names,
      flakeInputs ? inputs,
    }:
    builtins.listToAttrs (
      map (name: {
        inherit name;
        value = makeLinuxHost { inherit name flakeInputs; };
      }) names
    );

  homeModules = flakeInputs: [
    flakeInputs.stylix.homeModules.stylix
    flakeInputs.sops-nix.homeModules.sops
    ../home-manager/users/hibiki
  ];

  makeHome =
    {
      username,
      system,
      osConfig ? null,
      flakeInputs ? inputs,
      modules ? homeModules flakeInputs,
      isStandalone ? true,
    }:
    flakeInputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import flakeInputs.nixpkgs { inherit system; };
      extraSpecialArgs =
        {
          inputs = flakeInputs;
          inherit system username isStandalone;
        }
        // flakeInputs.nixpkgs.lib.optionalAttrs (osConfig != null) {
          inherit osConfig;
        };
      inherit modules;
    };
in
{
  inherit
    importHostConfiguration
    importModuleSiblings
    linuxModules
    makeHome
    makeLinuxHost
    makeLinuxHosts
    makeNixosSystem
    sharedNixosModules
    systemDarwin
    systemLinux
    ;
}
