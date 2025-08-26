{...}: {
  home.shellAliases = {
    vim = "nvim";

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

    sudo = "doas";

    ta = "tmux attach";
    tls = "tmux ls";
    ts = "tmux new-session -s";
    tks = "tmux kill-session -t";
  };
}
