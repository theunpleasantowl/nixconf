{
  config,
  lib,
  ...
}:
{
  programs = {
    senpai = {
      enable = true;
      config =
        lib.mkIf (lib.any (name: lib.hasPrefix "ircbouncer/" name) (builtins.attrNames config.sops.secrets))
          {
            address = config.sops.secrets."ircbouncer/address".path;
            username = config.sops.secrets."ircbouncer/username".path;
            password = config.sops.secrets."ircbouncer/password".path;
            nickname = config.sops.secrets."ircbouncer/username".path;
          };
    };
  };
}
