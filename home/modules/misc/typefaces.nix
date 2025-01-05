{pkgs, ...}: {
  home.packages = with pkgs; [
    # Serif
    libre-baskerville
    libre-caslon
    garamond-libre
    medio

    # NerdFonts
    nerd-fonts.bigblue-terminal
    nerd-fonts.blex-mono
    nerd-fonts.fira-code
    nerd-fonts.gohufont
    nerd-fonts.heavy-data
    nerd-fonts.sauce-code-pro
    nerd-fonts.terminess-ttf
    nerd-fonts.tinos
  ];
  fonts.fontconfig.enable = true;
}
