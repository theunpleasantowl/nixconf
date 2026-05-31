{
  lib,
  pkgs,
  system,
  ...
}:
let
  isDarwin = builtins.match ".*-darwin" system != null;
  isLinux = builtins.match ".*-linux" system != null;
in
{
  imports = [
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

  home.packages =
    with pkgs;
    [
      aria2
      browsh
      eza
      fastfetch
      fd
      ffmpeg
      git-extras
      glow
      jq
      lazygit
      nix-index
      stow
      sops
      yq-go
      yt-dlp
      weechat
      nethack
    ]
    ++ lib.optionals (pkgs.stdenv.isLinux) [
      ethtool
      strace
      iftop
      iotop
      lm_sensors
      lsof
      ltrace
      sysstat
      usbutils
      pciutils
    ];

  features = {
    media.enable = true;
  }
  // lib.optionalAttrs isLinux {
    ide.enable = true;
    gaming = {
      enable = true;
      retroarch = true;
      emulators = true;
      extraGames = true;
    };
  };

  programs.home-manager.enable = true;
}
// lib.optionalAttrs isLinux {
  wm.gnome.enable = true;
}
