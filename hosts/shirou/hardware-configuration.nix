{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader
  boot.loader.limine.enable = true;
  boot.loader.limine.secureBoot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d5e870f5-db05-4a66-a411-eff9d07e7809";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "noatime"
    ];
  };

  boot.tmp.cleanOnBoot = true;
  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/78b318b0-7fe8-4620-bc7f-9a215fbc507f";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7D55-2A70";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/d5e870f5-db05-4a66-a411-eff9d07e7809";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/d5e870f5-db05-4a66-a411-eff9d07e7809";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/d5e870f5-db05-4a66-a411-eff9d07e7809";
    fsType = "btrfs";
    options = [
      "subvol=log"
      "compress=zstd"
      "noatime"
    ];
  };

  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # RAM Size in GB
    }
  ];
  # https://nixos.wiki/wiki/Hibernation
  # BTRFS: sudo btrfs inspect-internal map-swapfile -r /var/lib/swapfile
  boot.kernelParams = [ "resume_offset=14763942" ];
  boot.resumeDevice = "/dev/disk/by-uuid/d5e870f5-db05-4a66-a411-eff9d07e7809";
  features.linux.powerManagement.enable = true;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
