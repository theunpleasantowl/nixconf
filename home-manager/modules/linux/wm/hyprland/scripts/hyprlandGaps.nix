{pkgs, ...}:
pkgs.writeShellScriptBin "hyprlandGaps" ''
  #!/bin/sh

  PATH_DECOR="$HOME/.config/hypr/hyprland.conf"
  INTERVAL_IN=2
  INTERVAL_OUT=8

  _get_gaps () {
    gap_in_current=$(${pkgs.hyprland}/bin/hyprctl getoption general:gaps_in | cut -d' ' -f3)
    gap_out_current=$(${pkgs.hyprland}/bin/hyprctl getoption general:gaps_out | cut -d' ' -f3)
  }

  _set_gaps () {
    ${pkgs.hyprland}/bin/hyprctl keyword general:gaps_in $gap_in_new
    ${pkgs.hyprland}/bin/hyprctl keyword general:gaps_out $gap_out_new
  }

  _get_gaps
  case "$1" in
    tog)
      if [ "$gap_in_current" -gt 0 ]; then
        gap_in_new=0
        gap_out_new=0
      else
        gap_in_new=$(${pkgs.gnugrep}/bin/grep gaps_in "$PATH_DECOR" | ${pkgs.gawk}/bin/awk -F'[^0-9]+' '{ print $2 }')
        gap_out_new=$(${pkgs.gnugrep}/bin/grep gaps_out "$PATH_DECOR" | ${pkgs.gawk}/bin/awk -F'[^0-9]+' '{ print $2 }')
      fi
      ;;
    dec)
      if [ "$gap_in_current" -gt 0 ]; then
        gap_in_new=$(( gap_in_current - INTERVAL_IN ))
        gap_out_new=$(( gap_out_current - INTERVAL_OUT ))
      else
        exit 0
      fi
      ;;
    inc)
      gap_in_new=$(( gap_in_current + INTERVAL_IN ))
      gap_out_new=$(( gap_out_current + INTERVAL_OUT ))
      ;;
    *)
      exit 1
  esac

  _set_gaps

  # Assure Alignment
  _get_gaps
  if [ "$gap_in_current" -le 0 ] || [ "$gap_out_current" -le 0 ]; then
    ${pkgs.hyprland}/bin/hyprctl keyword decoration:rounding 0
    gap_in_new=0
    gap_out_new=0
    _set_gaps
  else
    ${pkgs.hyprland}/bin/hyprctl keyword decoration:rounding $(${pkgs.gnugrep}/bin/grep rounding "$PATH_DECOR" | ${pkgs.gawk}/bin/awk -F'[^0-9]+' '{ print $2 }')
  fi
''
