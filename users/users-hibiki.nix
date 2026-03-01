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

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpPbFIeQfDngydE1VIrdDrfSoyFlOybZ/n+lmrb338g"
    ];
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs system username;
      isStandalone = false;
    };

    sharedModules = [ inputs.sops-nix.homeModules.sops ];

    users.${username} = {
      imports = [
        ../home-manager/users/hibiki
      ];
    };
  };
}
