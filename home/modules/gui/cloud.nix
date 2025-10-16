{pkgs, ...}: {
  home.packages = with pkgs; [
    anki-bin
    ferdium
    joplin-desktop
    keepassxc
    nextcloud-client

    # Web
    cider
    ferdium
    firefox
    steam
    thunderbird
    vesktop
  ];
}
