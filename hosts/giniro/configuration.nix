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
  ];
  system.stateVersion = "25.05";

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
    package = config.boot.kernelPackages.nvidiaPackages.stable;

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

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;

  # Packages
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/shadesmear-dark.yaml";
    polarity = "dark";
  };

  features = {
    gaming = {
      enable = true;
      steam.enable = true;
    };

    linux = {
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
