{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    helvum
    mpv
    thunderbird
  ];
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
}
