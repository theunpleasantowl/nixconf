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

  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-uuid/6eca11f6-921e-4d61-8f48-2473aa91bcce";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/05672396-a9de-46d1-b97d-81e54deef5a4";
    fsType = "btrfs";
    options = ["subvol=root" "compress=zstd" "noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/05672396-a9de-46d1-b97d-81e54deef5a4";
    fsType = "btrfs";
    options = ["subvol=home" "compress=zstd" "noatime"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/05672396-a9de-46d1-b97d-81e54deef5a4";
    fsType = "btrfs";
    options = ["subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/05672396-a9de-46d1-b97d-81e54deef5a4";
    fsType = "btrfs";
    options = ["subvol=log" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  # SSD Mounts
  fileSystems."/mnt/local/SteamSSD" = {
    device = "/dev/disk/by-uuid/5900c530-0d69-4b81-8516-e49eb7fa48a0";
    fsType = "btrfs";
    options = ["compress=zstd" "noatime" "nofail"];
  };

  fileSystems."/mnt/local/SteamNVMe" = {
    device = "/dev/disk/by-uuid/2882E19F82E1722C";
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
