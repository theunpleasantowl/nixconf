{pkgs, ...}: {
  home.packages = with pkgs; [
    # Serif
    libre-baskerville
    libre-caslon
    garamond-libre
    medio

    # Sans-Serif
    lato
    ibm-plex
    montserrat

    # Slab-Serif
    zilla-slab
    courier-prime

    # Display
    raleway
    league-gothic

    # NerdFonts
    ## Serif
    nerd-fonts.tinos
    ## Monospace
    nerd-fonts.blex-mono
    nerd-fonts.fira-code
    nerd-fonts.gohufont
    nerd-fonts.sauce-code-pro
    nerd-fonts.terminess-ttf
    nerd-fonts.bigblue-terminal
    ## Display
    nerd-fonts.heavy-data
  ];
  fonts.fontconfig.enable = true;
}
