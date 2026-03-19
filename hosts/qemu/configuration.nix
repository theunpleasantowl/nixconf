{ lib, pkgs, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  system.stateVersion = "26.05";

  networking.hostName = "qemu";

  virtualisation = {
    memorySize = 4096;
    cores = 4;
    graphics = true;
    diskSize = 20480;
    qemu.options = [
      "-vga virtio"
      "-device virtio-rng-pci"
    ];
    forwardPorts = [
      { from = "host"; host.port = 2222; guest.port = 22; }
    ];
  };

  features.linux.plymouth.enable = false;
  features.linux.desktop.gnome.enable = true;
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
