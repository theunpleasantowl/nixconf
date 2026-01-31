{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      # Video settings
      geometry = "50%:50%";
      autofit-larger = "90%x90%";
      keep-open = "yes";

      # Screenshots
      screenshot-template = "%F-[%P]";
      screenshot-format = "png";
      screenshot-png-compression = 0;
      screenshot-tag-colorspace = "yes";
      screenshot-high-bit-depth = "yes";

      # Audio settings
      alang = "jpn,en";
    };

    profiles = {
      "extension.webm" = {
        loop-file = "inf";
      };
      "extension.gif" = {
        loop-file = "inf";
      };
    };

    scripts = with pkgs.mpvScripts; [
      mpv-webm
      thumbfast
      uosc
    ];
  };
}
