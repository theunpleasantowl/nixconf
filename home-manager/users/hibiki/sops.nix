{
  config,
  lib,
  ...
}:
{
  sops = lib.mkIf (builtins.pathExists ./secrets.yaml) {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets.anki-password = { };
  };
}
