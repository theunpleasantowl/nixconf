{pkgs, ...}: {
  home.packages = with pkgs; [
    feh
    gimp
    nsxiv
    swayimg
  ];
}
