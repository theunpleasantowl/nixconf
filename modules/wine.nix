{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks
  ];
}
