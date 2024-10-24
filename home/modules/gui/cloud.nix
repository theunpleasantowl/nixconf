{pkgs, ...}: {
  home.packages = with pkgs; [
    ferdium
    joplin-desktop
    keepassxc
    nextcloud-client
  ];
}
