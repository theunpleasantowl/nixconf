{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bc334770-3956-48f2-96f8-75988f8e8de4";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd" "noatime"];
  };

  boot.initrd.luks.devices."nvme".device = "/dev/disk/by-uuid/899689a7-b1d5-4af6-a74a-e844252d0e53";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/bc334770-3956-48f2-96f8-75988f8e8de4";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd" "noatime"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/bc334770-3956-48f2-96f8-75988f8e8de4";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/bc334770-3956-48f2-96f8-75988f8e8de4";
    fsType = "btrfs";
    options = ["subvol=log" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CAF2-8D4C";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  # SSD Mounts
  fileSystems."/mnt/local/SteamSSD" = {
    device = "/dev/disk/by-uuid/a7045311-23ef-4e09-b18a-aecebc4b8769";
    fsType = "btrfs";
    options = ["compress=zstd" "noatime" "nofail"];
  };

  fileSystems."/mnt/local/SteamNVMe" = {
    device = "/dev/disk/by-uuid/16F16DD7609F9BE6";
    fsType = "ntfs-3g";
    options = ["rw" "uid=1000" "nofail"];
  };

  fileSystems."/mnt/nfs/SteamNAS" = {
    device = "oms:/zpool1/steamgames";
    fsType = "nfs4";
    options = ["x-systemd.automount" "noauto" "_netdev"];
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
