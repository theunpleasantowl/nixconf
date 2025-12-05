{
  # Garbage collect the Nix store
  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
  };
}
