{
  ### Shell ###
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "agnoster"; # Set the theme of your choice
    plugins = [
      # List of oh-my-zsh plugins to enable
      "fancy-ctrl-z"
      "git"
      "git-auto-fetch"
      "git-extras"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh.shellAliases = {
    vim = "nvim";

    ta = "tmux attach";
    tls = "tmux ls";
    ts = "tmux new-session -s";
    tks = "tmux kill-session -t";

    ls = "eza --color=always --group-directories-first --icons";
    ll = "eza -la --icons --octal-permissions --group-directories-first";
    l = "eza -bGF --header --git --color=always --group-directories-first --icons";
    llm = "eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons";
    la = "eza --long --all --group --group-directories-first";
    lx = "eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons";
    lS = "eza -1 --color=always --group-directories-first --icons";
    lt = "eza --tree --level=2 --color=always --group-directories-first --icons";

    egrep = "egrep --color=auto";
    fgrep = "fgrep --color=auto";
    grep = "grep --color=auto";

    gs = "git status";

    sudo = "doas";
  };

  programs.zsh.initExtra = ''
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
        cd $NIX_PATH/hosts
        nix flake update && doas nixos-rebuild switch --flake .#
        cd -
      fi
        cd ~/.config/nixdots/home/
        nix flake update && home-manager switch --flake ./
        cd -
    }
  '';
}
