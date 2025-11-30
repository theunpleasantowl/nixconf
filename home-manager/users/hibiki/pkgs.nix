{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    # Utilities
    aria2
    browsh # terminal web client
    btop # replacement of htop/nmon
    ethtool
    eza
    fastfetch
    fd
    ffmpeg
    git-extras
    glow
    iftop # network monitoring
    iotop # io monitoring
    jq # json utility
    lazygit
    lm_sensors # for `sensors` command
    lsof # list open files
    ltrace # library call monitoring
    nix-index
    pciutils # lspci
    stow
    strace # syscall monitoring
    sysstat
    usbutils # lsusb
    yq-go
    yt-dlp

    inputs.nixvim.packages.${pkgs.system}.default

    # chat
    weechat

    # Misc
    nethack
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
