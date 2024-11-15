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
      function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        	builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
      function nup() {
        local NIX_PATH="$HOME/.config/nixconf"
        if command -v nixos-rebuild  > /dev/null; then
          cd $NIX_PATH/nixos/
          nix flake update && doas nixos-rebuild switch --flake .#
          cd -
        fi
          cd $NIX_PATH/home/
          nix flake update && home-manager switch --flake ./
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
