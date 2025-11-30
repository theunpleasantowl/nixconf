{config, ...}: {
  ### Shell ###
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
           function nup() {
             local NIX_PATH="$HOME/.config/nixconf"
             cd $NIX_PATH && nix flake update
             if command -v nixos-rebuild  > /dev/null; then
               nh os switch ./ --ask
      else
               nh home switch ./ --ask
             fi
             cd -
           }
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
