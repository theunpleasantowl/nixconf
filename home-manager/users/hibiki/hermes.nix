{ inputs, ... }:
{
  imports = [ inputs.hermes-agent.homeManagerModules.default ];

  programs.hermes-agent = {
    enable = true;
    desktop.enable = true;
  };

  # Hermes Desktop uses this URL to connect to a remote `hermes serve` backend.
  home.sessionVariables.HERMES_DESKTOP_REMOTE_URL = "http://192.168.1.210:9119";
}
