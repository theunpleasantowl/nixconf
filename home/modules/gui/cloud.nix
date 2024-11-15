{pkgs, ...}: {
  home.packages = with pkgs; [
    anki
    ferdium
    joplin-desktop
    keepassxc
    nextcloud-client

    # Web
    cider
    discord
    ferdium
    firefox
    steam
    thunderbird
  ];
}
