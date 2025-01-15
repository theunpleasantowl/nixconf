# This file delcares Generic System Packages.
# We also import package _modules_ via imports.
{pkgs, ...}: {
  imports = [
    ./modules/gui
    ./modules/misc
    ./modules/shell
    ./modules/utils
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    # Utilities
    browsh # terminal web client
    btop # replacement of htop/nmon
    ethtool
    eza
    fastfetch
    git-extras
    glow
    iftop # network monitoring
    iotop # io monitoring
    jq # json utility
    lazygit
    lm_sensors # for `sensors` command
    lsof # list open files
    ltrace # library call monitoring
    pciutils # lspci
    strace # syscall monitoring
    sysstat
    usbutils # lsusb
    yq-go

    # Secrets
    age
    sops

    # Misc
    nethack
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
