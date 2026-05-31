{
  config,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../stylix-themes/katy.nix
  ];
  system.stateVersion = "26.05";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "neptune";
  networking.networkmanager.enable = true;

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
    ];
  };

  # Packages
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  hardware.ckb-next = {
    enable = true;
  };

  fileSystems."/media/hibiki/gearshare" = {
    device = "//oms/gearshare";
    fsType = "cifs";
    options = [
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "_netdev"
      "nofail"
      "x-gvfs-show"
      "x-gvfs-name=gearshare"

      "vers=3.0"
      "serverino"
      "uid=1000"
      "gid=${toString config.users.groups.users.gid}"

      "credentials=${config.sops.secrets.smb-gearshare.path}"
    ];
  };

  features = {
    gaming = {
      enable = true;
      steam.enable = true;
    };

    linux = {
      printing.enable = true;
      bluetooth.enable = true;
      fwupd.enable = true;
      wifi.enable = true;

      desktop = {
        gnome.enable = true;
        hyprland.enable = true;
        windowmaker.enable = true;
      };

      snapper = {
        enable = true;
        configs = {
          home = {
            subvolume = "/home";
          };
        };
      };

      wine.enable = true;
    };

    development.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
      users = [ "hibiki" ];
    };

    ollama = {
      enable = true;
      acceleration = "vulkan";
      models = [
        "qwen2.5-coder:14b-instruct-q4_K_M"
      ];
    };

    remote-access = {
      ssh.enable = true;
      rdp.enable = true;
      sunshine.enable = true;
    };
  };
}
