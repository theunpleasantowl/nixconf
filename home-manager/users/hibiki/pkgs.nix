{
  inputs,
  lib,
  pkgs,
  system,
  ...
}: let
  isDarwin = builtins.match ".*-darwin" system != null;
  isLinux = builtins.match ".*-linux" system != null;
in {
  imports =
    [
      ../../modules/shared
    ]
    # Conditionally import platform-specific modules
    ++ lib.optionals isLinux [
      ../../modules/linux
    ]
    ++ lib.optionals isDarwin [
      ../../modules/darwin
    ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs;
    [
      aria2 # download client
      browsh # terminal web client
      btop # replacement of htop/nmon
      eza # modern ls
      fastfetch
      fd # find tool
      ffmpeg
      git-extras
      glow # md viewer
      jq # json utility
      lazygit
      nix-index
      stow
      yq-go # yaml/json viewer
      yt-dlp
      weechat
      nethack
      inputs.nixvim.packages.${pkgs.system}.default
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      ethtool
      strace # syscall monitoring
      iftop # network monitoring
      iotop # io monitoring
      lm_sensors # for `sensors` command
      lsof # list open files
      ltrace # library call monitoring
      sysstat # perf monitoring
      usbutils # lsusb
      pciutils # lspci
    ]
    ++ lib.optionals (pkgs.stdenv.isDarwin) [
      # TBD
    ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
