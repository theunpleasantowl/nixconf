{pkgs, ...}: {
  services.xserver.windowManager.windowmaker.enable = true;

  environment.systemPackages = with pkgs; [
    windowmaker.dockapps.AlsaMixer-app
    windowmaker.dockapps.wmCalClock
    windowmaker.dockapps.wmcube
    windowmaker.dockapps.wmsm-app
    windowmaker.dockapps.wmsystemtray
  ];
}
