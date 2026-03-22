{ config, lib, ... }:
let
  sopsUser = "hibiki";
  sopsHome = config.users.users.${sopsUser}.home;
in
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
    age.keyFile = "${sopsHome}/.config/sops/age/keys.txt";

    secrets.smb-gearshare = {
      mode = "0740";
      owner = sopsUser;
      group = "users";
    };
  };
}
