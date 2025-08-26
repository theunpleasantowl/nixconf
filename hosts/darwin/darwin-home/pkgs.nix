# This file delcares Generic System Packages.
# We also import package _modules_ via imports.
{pkgs, ...}: {
  imports = [
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
    eza
    fastfetch
    git-extras
    glow
    iftop # network monitoring
    jq # json utility
    lazygit
    lsof # list open files
    pciutils # lspci
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
