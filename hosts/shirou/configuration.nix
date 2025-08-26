{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "shirou";
  networking.networkmanager.enable = true;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;

  # Enable doas
  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = ["wheel"];
        keepEnv = true;
        persist = true;
      }
    ];
  };

  # Users
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.hibiki = {
    isNormalUser = true;
    description = "hibiki";
    extraGroups = ["networkmanager" "wheel"];
  };

  # Packages
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    tpm2-tss
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
