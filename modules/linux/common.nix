{
  config,
  lib,
  pkgs,
  ...
}:
let
  hasDesktop = config.features.linux.desktop.anyEnabled;
in
{
  powerManagement.enable = true;

  # Time Zone
  time.timeZone = "America/New_York";

  # Internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
    inputMethod = lib.mkIf hasDesktop {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
        ];
      };
    };
  };

  # System Typefaces — only needed on desktop hosts
  fonts = lib.mkIf hasDesktop {
    enableDefaultPackages = true;
    packages = with pkgs; [
      corefonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      vista-fonts
    ];
  };

  # Audio via PipeWire — only needed on desktop hosts
  services.pulseaudio.enable = lib.mkDefault (!hasDesktop);
  security.rtkit.enable = lib.mkDefault hasDesktop;
  services.pipewire = lib.mkIf hasDesktop {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    git
    tpm2-tss
  ];
}
