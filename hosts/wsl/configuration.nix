{ lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  system.stateVersion = "26.05";

  wsl.enable = true;
  wsl.defaultUser = "hibiki";
  wsl.useWindowsDriver = true;

  networking.hostName = "wsl";

  powerManagement.enable = lib.mkForce false;
  features.linux.plymouth.enable = false;

  services.pipewire.enable = lib.mkForce false;
  services.pulseaudio.enable = lib.mkForce false;
  security.rtkit.enable = lib.mkForce false;

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

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/shadesmear-dark.yaml";
    polarity = "dark";
  };
}
