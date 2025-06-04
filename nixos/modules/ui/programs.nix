{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    discord
    ferdium
    firefox
    helvum
    keepassxc
    mpv
    nextcloud-client
    thunderbird
  ];
}
