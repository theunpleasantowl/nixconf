{pkgs, ...}: {
  imports = [
    ./modules/gui
    ./modules/shell
    ./modules/utils
  ];

  home.packages = with pkgs; [
    fastfetch
    git-extras
    nethack
    lazygit
    browsh

    # Utilities
    btop # replacement of htop/nmon
    ethtool
    eza
    glow
    iftop # network monitoring
    iotop # io monitoring
    jq
    lm_sensors # for `sensors` command
    lsof # list open files
    ltrace # library call monitoring
    nix-output-monitor
    pciutils # lspci
    strace # system call monitoring
    sysstat
    usbutils # lsusb
    yq-go

    ## Fonts
    terminus-nerdfont
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
