{pkgs, ...}: {
  home.packages = with pkgs; [
    gimp
    feh
    nsxiv
    swayimg
  ];
}
