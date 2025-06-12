{...}: {
  home-manager.users.icarus = {pkgs, ...}: {
    home.packages = with pkgs; [
      anki
      ghostty
      gimp

      # Utilities
      browsh # terminal web client
      btop # replacement of htop/nmon
      ethtool
      eza
      fastfetch
      fd
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

      # chat
      weechat

      # Secrets
      age
      sops

      # Misc
      nethack
    ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
