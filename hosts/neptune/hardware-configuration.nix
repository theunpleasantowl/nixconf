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
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.tmp.cleanOnBoot = true;
  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/ebba8df2-74ac-4562-b8da-654107b39933";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/94fb701d-fe47-424c-b3c6-b3d4555db96a";
    fsType = "btrfs";
    options = [
      "subvol=root"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/94fb701d-fe47-424c-b3c6-b3d4555db96a";
    fsType = "btrfs";
    options = [
      "subvol=home"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/94fb701d-fe47-424c-b3c6-b3d4555db96a";
    fsType = "btrfs";
    options = [
      "subvol=nix"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/94fb701d-fe47-424c-b3c6-b3d4555db96a";
    fsType = "btrfs";
    options = [
      "subvol=log"
      "compress=zstd"
      "noatime"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C3B5-4180";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/mnt/local/SteamNVMe" = {
    device = "/dev/disk/by-uuid/2882E19F82E1722C";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };

  fileSystems."/mnt/local/SteamSSD1" = {
    device = "/dev/disk/by-uuid/1EE453EE62BE6116";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };
  fileSystems."/mnt/local/SteamSSD2" = {
    device = "/dev/disk/by-uuid/6974F0E5738841AC";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };
  fileSystems."/mnt/local/SteamSSD3" = {
    device = "/dev/disk/by-uuid/746808FC0449910B";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };

  fileSystems."/mnt/nfs/SteamNAS" = {
    device = "oms:/zpool1/steamgames";
    fsType = "nfs4";
    options = [
      "x-systemd.automount"
      "noauto"
      "_netdev"
    ];
  };

  fileSystems."/run/media/hibiki/gearshare" = {
    device = "//oms/gearshare";
    fsType = "cifs";
    options = [
      "credentials=/etc/nixos/smb-secrets"
      "x-systemd.automount"
      "noauto"
      "_netdev"
      "uid=1000"
      "gid=100"
      "file_mode=0644"
      "dir_mode=0755"
    ];
  };

  zramSwap.enable = true;

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
