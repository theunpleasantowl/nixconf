{pkgs, ...}: {
  home.packages = with pkgs; [
    # Notes and Access
    joplin-desktop
    keepassxc
    nextcloud-client
    # Web
    ferdium
    firefox
    thunderbird
  ];
}
