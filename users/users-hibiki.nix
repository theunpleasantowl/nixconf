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

  # Configure home-manager for this user
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs system username;
    };

    users.${username} = {
      imports = [
        ../home-manager/users/hibiki
      ];
    };
  };
}
