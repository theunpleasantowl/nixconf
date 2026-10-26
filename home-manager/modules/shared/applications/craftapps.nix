# ArtCraft apps (https://github.com/olafkfreund/nix-craftapps)
#
# The apps are storytold's clean-room takes on familiar creative tools:
#   photocraft  -> Photoshop
#   filmcraft   -> Premiere Pro
#   wordcraft   -> Word
#   gridcraft   -> Excel
#   deckcraft   -> PowerPoint
#   soundcraft  -> Pro Tools
{ ... }:
{
  programs.craftapps = {
    enable = true;

    apps = {
      photocraft.enable = true;
      filmcraft.enable = true;
      wordcraft.enable = true;
      gridcraft.enable = true;
      deckcraft.enable = true;
      soundcraft.enable = true;
    };
  };
}
