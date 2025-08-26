{pkgs, ...}: let
  retroarchWithCores = pkgs.retroarch.withCores (
    cores:
      with cores; [
        beetle-pce
        beetle-psx
        beetle-saturn
        beetle-vb
        beetle-wswan
        bluemsx
        bsnes
        citra
        fbneo
        flycast
        genesis-plus-gx
        melonds
        mesen
        mgba
        mupen64plus
        np2kai
        pcsx2
        ppsspp
        sameboy
      ]
  );
in {
  home.packages = with pkgs; [
    discord
    dolphin-emu
    steam
    wine
    retroarchWithCores
  ];
}
