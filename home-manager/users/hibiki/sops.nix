{
  config,
  lib,
  ...
}:
{
  sops = lib.mkIf (builtins.pathExists ./secrets/secrets.yaml) {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "anki/username" = {
        path = "${config.home.homeDirectory}/.config/sops-nix/anki/userFile";
      };
      "anki/passkey" = {
        path = "${config.home.homeDirectory}/.config/sops-nix/anki/keyFile";
      };
      "ircbouncer/address" = { };
      "ircbouncer/username" = { };
      "ircbouncer/password" = { };
    };
  };
}
