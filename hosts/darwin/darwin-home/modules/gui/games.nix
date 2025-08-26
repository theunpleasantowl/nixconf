{pkgs, ...}: {
  home.packages = with pkgs; [
    discord
    steam
    wine
  ];
}
