{
  config,
  lib,
  ...
}: let
  cfg = config.features.remote-access;
in {
  options.features.remote-access = {
    ssh = {
      enable = lib.mkEnableOption "SSH server";

      allowRoot = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Allow root login via SSH";
      };
    };

    rdp = {
      enable = lib.mkEnableOption "RDP access (GNOME Remote Desktop)";
    };

    sunshine = {
      enable = lib.mkEnableOption "Sunshine game streaming";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.ssh.enable {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin =
            if cfg.ssh.allowRoot
            then "yes"
            else "no";
        };
      };
    })

    (lib.mkIf cfg.rdp.enable {
      services.gnome.gnome-remote-desktop.enable = true;
      systemd.services.gnome-remote-desktop = {
        wantedBy = ["graphical.target"];
      };
      networking.firewall.allowedTCPPorts = [3389];
    })

    (lib.mkIf cfg.sunshine.enable {
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
      };
    })
  ];
}
