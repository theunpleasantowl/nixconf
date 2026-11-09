{ pkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
  };

  nixpkgs.overlays = [
    (import ../lib/overlays/anki.nix)
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
