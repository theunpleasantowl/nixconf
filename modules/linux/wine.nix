{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bottles
    wineWowPackages.stagingFull
    winetricks
  ];
}
