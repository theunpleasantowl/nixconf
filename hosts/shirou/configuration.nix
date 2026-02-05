{ pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  system.stateVersion = "25.05";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "shirou";
  networking.networkmanager.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
    ];
  };

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;

  # Users
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.hibiki = {
    isNormalUser = true;
    description = "hibiki";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Packages
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/shadesmear-dark.yaml";
    #polarity = "dark";
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
      wine.enable = true;

      snapper = {
        enable = true;
        configs = {
          home = {
            subvolume = "/home";
          };
        };
      };
    };
  };
}
