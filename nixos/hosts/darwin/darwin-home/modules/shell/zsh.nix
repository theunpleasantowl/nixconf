{config, ...}: {
  ### Shell ###
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtra = ''
      function nup() {
        local NIX_PATH="$HOME/.config/nixconf"
        if command -v nixos-rebuild  > /dev/null; then
          cd $NIX_PATH/nixos/
          nix flake update && nh os switch ./ --ask
          cd -
        fi
          cd $NIX_PATH/home/
          nix flake update && nh home switch ./ --ask
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
