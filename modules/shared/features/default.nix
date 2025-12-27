{lib, ...}: {
  imports = [
    ./gaming.nix
    ./desktop.nix
    ./development.nix
    ./media.nix
    ./remote-access.nix
  ];
}
