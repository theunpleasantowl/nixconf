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
    age.keyFile = "/home/hibiki/.config/sops/age/keys.txt";

    secrets.smb-gearshare = {
      mode = "0440";
      owner = "root";
      group = "root";
    };
  };
}
