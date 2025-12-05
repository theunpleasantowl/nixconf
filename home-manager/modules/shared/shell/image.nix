{pkgs, ...}: {
  home.packages = with pkgs; [
    feh
    nsxiv
    swayimg
  ];
}
