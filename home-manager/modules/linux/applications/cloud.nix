{pkgs, ...}: {
  programs.anki = {
    enable = true;
    style = "native";
    addons = [
      pkgs.ankiAddons.anki-connect
      pkgs.ankiAddons.review-heatmap
    ];
  };

  home.packages = with pkgs; [
    joplin-desktop
    keepassxc
    nextcloud-client

    # Web / Desktop
    cider
    delfin
    ferdium
    vesktop
  ];
}
