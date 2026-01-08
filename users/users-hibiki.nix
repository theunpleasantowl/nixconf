{
  pkgs,
  inputs,
  system,
  ...
}: let
  username = "hibiki";
in {
  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs system username;
      isStandalone = false;
    };

    users.${username} = {
      imports = [
        ../home-manager/users/hibiki
      ];
    };
  };
}
