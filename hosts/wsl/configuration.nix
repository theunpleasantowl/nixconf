{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../../stylix-themes/shadesmear-dark.nix
  ];

  system.stateVersion = "26.11";

  wsl.enable = true;
  wsl.defaultUser = "hibiki";
  wsl.useWindowsDriver = true;

  networking.hostName = "wsl";

  powerManagement.enable = lib.mkForce false;
  features.linux.plymouth.enable = false;

  features.development.enable = true;

  features.docker = {
    enable = true;
    storageDriver = "overlay2";
    users = [ "hibiki" ];
  };

  features.remote-access.ssh.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

}
