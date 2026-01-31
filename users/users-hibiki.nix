{
  pkgs,
  inputs,
  system,
  ...
}:
let
  username = "hibiki";
in
{
  programs.fish.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs system username;
      isStandalone = false;
    };

    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];

    users.${username} = {
      imports = [
        ../home-manager/users/hibiki
      ];
    };
  };
}
