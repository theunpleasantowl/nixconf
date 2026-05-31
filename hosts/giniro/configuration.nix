{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../stylix-themes/katy.nix
  ];
  system.stateVersion = "26.05";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "giniro";
  networking.networkmanager.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
    ];
  };

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

    # Sync mode is the default
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Boot into this specialisation for battery-saving offload mode
  specialisation = {
    offload.configuration = {
      system.nixos.tags = [ "offload" ];
      hardware.nvidia.prime.sync.enable = lib.mkForce false;
      hardware.nvidia.prime.offload = {
        enable = lib.mkForce true;
        enableOffloadCmd = lib.mkForce true;
      };
    };
  };

  # Packages
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  features = {
    gaming = {
      enable = true;
      steam.enable = true;
    };

    linux = {
      printing.enable = true;
      bluetooth.enable = true;
      fwupd.enable = true;
      wifi.enable = true;

      desktop = {
        gnome.enable = true;
        hyprland.enable = true;
      };
      snapper = {
        enable = true;
        configs = {
          home = {
            subvolume = "/home";
          };
        };
      };
      wine.enable = true;
    };

    remote-access = {
      ssh.enable = true;
    };
  };
}
