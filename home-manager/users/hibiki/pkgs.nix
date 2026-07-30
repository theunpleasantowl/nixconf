{
  lib,
  pkgs,
  system,
  osConfig ? null,
  ...
}:
let
  # Use the system string only for conditional imports (evaluated before pkgs is finalised).
  isLinuxImport = builtins.match ".*-linux" system != null;
  isDarwinImport = builtins.match ".*-darwin" system != null;

  # Use stdenv for everything else (the modern, non-deprecated approach).
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isQemu = (osConfig.networking.hostName or "") == "qemu";
in
{
  imports = [
    ../../modules/shared
  ]
  # Conditionally import platform-specific modules
  ++ lib.optionals isLinuxImport [
    ../../modules/linux
  ]
  ++ lib.optionals isDarwinImport [
    ../../modules/darwin
  ];

  nixpkgs.config = {
    allowUnfree = true;
    # TODO: Remove me
    permittedInsecurePackages = [
      "pnpm-10.29.2"
    ];
    ###
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
      emulators = false;
      rpcs3 = false;
      extraGames = true;
    };
  };

  programs.home-manager.enable = true;
}
// lib.optionalAttrs isLinuxImport {
  wm.gnome.enable = true;
}
