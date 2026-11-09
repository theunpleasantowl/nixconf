{ ... }:
{
  xdg.configFile = {
    "speech-dispatcher/speechd.conf".text = ''
      DefaultLanguage "en"
      DefaultModule "espeak-ng"
      Include "clients/*.conf"
    '';

    "speech-dispatcher/clients/hypnos.conf".text = ''
      BeginClient "*:HypnOS:*"
        DefaultLanguage "en"
      EndClient
    '';
  };
}
