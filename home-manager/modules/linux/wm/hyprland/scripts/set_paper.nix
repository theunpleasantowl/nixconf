{
  pkgs,
  lib,
  ...
}:
let
  set_paper = pkgs.writeShellScriptBin "set_paper" ''
    #!/bin/sh
    # Description: Set a wallpaper based on file type (video/image)
    # Usage: set_paper <file>
    # Example: set_paper /path/to/wallpaper.jpg
    #
    # HANDLERS:
    # feh (X11)
    # mpv (X11)
    # mpvpaper (Wayland)
    # swww (Wayland)

    PATH_PREVIOUS_WALLPAPER="$HOME/.cache/set_paper_previous_wallpaper.path"

    usage() {
      echo "Usage: $0 <file>"
      echo "Sets the wallpaper based on file type (image or video)."
      echo "Supported types: jpg, png, gif, mp4, mkv, etc."
      exit 1
    }

    # If no argument is provided, try to use the last wallpaper
    if [ "$#" -eq 0 ]; then
      if [ -f "$PATH_PREVIOUS_WALLPAPER" ]; then
        WALLPAPER=$(cat "$PATH_PREVIOUS_WALLPAPER")
        echo "Reusing last wallpaper: $WALLPAPER"
      else
        echo "Error: No wallpaper file provided and no previous wallpaper found."
        usage
      fi
    else
      WALLPAPER="$1"
    fi

    # Check if the file exists
    if [ ! -f "$WALLPAPER" ]; then
      echo "Error: File '$WALLPAPER' does not exist."
      exit 1
    fi

    # Save the wallpaper path for future use
    echo "$WALLPAPER" > "$PATH_PREVIOUS_WALLPAPER"

    # Determine MIME type
    MIME_TYPE=$(${pkgs.file}/bin/file --mime-type -b "$WALLPAPER")

    # Determine if the session is X11 or Wayland
    SESSION_TYPE=$(echo "$XDG_SESSION_TYPE")

    case "$MIME_TYPE" in
      video/*)
        if [ "$SESSION_TYPE" = "x11" ]; then
          echo "Setting video wallpaper with mpv on X11..."
          ${pkgs.mpv}/bin/mpv --loop --wid=0 "$WALLPAPER" &
        elif [ "$SESSION_TYPE" = "wayland" ]; then
          echo "Setting video wallpaper with mpvpaper on Wayland..."
          ${pkgs.mpvpaper}/bin/mpvpaper -o "no-audio --loop-playlist" '*' "$WALLPAPER" &
        else
          echo "Error: Unsupported session type '$SESSION_TYPE'."
          exit 1
        fi
        ;;
      image/*)
        if [ "$SESSION_TYPE" = "x11" ]; then
          echo "Setting image wallpaper with feh on X11..."
          ${pkgs.feh}/bin/feh --bg-scale "$WALLPAPER"
        elif [ "$SESSION_TYPE" = "wayland" ]; then
          echo "Setting image wallpaper with swww on Wayland..."
          # Initialize swww daemon if not running
          if ! ${pkgs.procps}/bin/pgrep -x swww-daemon > /dev/null; then
            ${pkgs.swww}/bin/swww-daemon &
            sleep 0.5
          fi
          ${pkgs.swww}/bin/swww img -t outer "$WALLPAPER"
        else
          echo "Error: Unsupported session type '$SESSION_TYPE'."
          exit 1
        fi
        ;;
      *)
        echo "Error: Unsupported file type '$MIME_TYPE'"
        exit 1
        ;;
    esac

    exit 0
  '';
  set_paper_random = pkgs.writeShellScriptBin "set_paper_random" ''
    #!/bin/sh
    # Usage: set_paper_random <directory>
    # Sets a random wallpaper from the specified directory

    if [ "$#" -eq 0 ]; then
      WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
    else
      WALLPAPER_DIR="$1"
    fi

    if [ ! -d "$WALLPAPER_DIR" ]; then
      echo "Error: Directory '$WALLPAPER_DIR' does not exist."
      exit 1
    fi

    # Find a random image or video file
    RANDOM_FILE=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \
      \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \
      -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) \
      | ${pkgs.coreutils}/bin/shuf -n 1)

    if [ -z "$RANDOM_FILE" ]; then
      echo "Error: No suitable wallpaper files found in '$WALLPAPER_DIR'."
      exit 1
    fi

    echo "Setting random wallpaper: $RANDOM_FILE"
    ${set_paper}/bin/set_paper "$RANDOM_FILE"
  '';
in
{
  home.packages = lib.mkDefault [
    set_paper
    set_paper_random

    # Dependencies
    pkgs.file
    pkgs.procps

    # X11 handlers
    pkgs.feh
    pkgs.mpv

    # Wayland handlers
    pkgs.swww
    pkgs.mpvpaper
  ];

  # Create a systemd service for swww daemon (Wayland only)
  systemd.user.services.swww = {
    Unit = {
      Description = "Wayland wallpaper daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=Hyprland";
    };

    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
