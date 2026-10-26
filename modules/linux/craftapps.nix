# The ArtCraft apps look for fonts in /usr/share/fonts only (they do not use
# fontconfig). The NixOS module provides that link; the apps themselves are
# installed per-user by home-manager.
{
  programs.craftapps = {
    enable = true;
    linkFonts = true;
  };
}
