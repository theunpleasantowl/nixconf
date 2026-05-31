{ lib, ... }:
{
  security.doas = {
    enable = lib.mkDefault true;
    extraRules = [
      {
        groups = [ "wheel" ];
        keepEnv = true;
        persist = lib.mkDefault true;
      }
    ];
  };
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets.smb-gearshare = {
      mode = "0400";
    };
  };
}
