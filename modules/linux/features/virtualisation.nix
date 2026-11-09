{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.virtualisation;
in
{
  options.features.virtualisation = {
    enable = lib.mkEnableOption "libvirt, virt-manager and QEMU/KVM";

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of users to add to the libvirtd group.";
      example = [ "alice" ];
    };

    swtpm = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the software TPM emulator (swtpm) backend.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;

        # QEMU runs as root so it can open raw block devices such as
        # /dev/disk/by-id/nvme-... without extra ACLs or udev rules.
        runAsRoot = true;

        swtpm.enable = cfg.swtpm;
      };

      # Do not start domains automatically; the Windows disk is also
      # usable from the bare-metal installation.
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    programs.virt-manager.enable = true;

    # Stable paths for the OVMF Secure Boot firmware. The store paths
    # change on every nixpkgs update, the symlinks below do not.
    systemd.tmpfiles.rules = [
      "d /var/lib/libvirt/ovmf 0755 root root -"
      "L+ /var/lib/libvirt/ovmf/OVMF_CODE.fd - - - - ${pkgs.OVMFFull.fd}/FV/OVMF_CODE.fd"
      "L+ /var/lib/libvirt/ovmf/OVMF_VARS.ms.fd - - - - ${pkgs.OVMFFull.fd}/FV/OVMF_VARS.ms.fd"
    ];

    # virtio-win provides the Windows drivers ISO used by virt-manager.
    environment.systemPackages = [
      pkgs.virtio-win
      pkgs.spice-gtk
    ];

    users.users = lib.mkMerge (
      map (user: {
        ${user}.extraGroups = [ "libvirtd" ];
      }) cfg.users
    );
  };
}
