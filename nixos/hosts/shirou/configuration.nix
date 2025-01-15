{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "shirou"; # Define your hostname.
  networking.networkmanager.enable = true;

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
  programs.firefox.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    tpm2-tss
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05";
}
