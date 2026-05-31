{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "nup" ''
      set -e

      remote_host=""
      nh_args=()

      while [ "$#" -gt 0 ]; do
        case "$1" in
          --remote)
            if [ "$#" -lt 2 ]; then
              echo "nup: --remote requires a host name" >&2
              exit 2
            fi
            remote_host="$2"
            shift 2
            ;;
          --remote=*)
            remote_host="''${1#--remote=}"
            shift
            ;;
          -h|--help)
            echo "Usage: nup [--remote HOSTNAME] [NH_ARGS...]"
            exit 0
            ;;
          *)
            nh_args+=("$1")
            shift
            ;;
        esac
      done

      NIX_PATH="$HOME/.config/nixconf"
      cd "$NIX_PATH"

      nix flake update

      if command -v nixos-rebuild >/dev/null 2>&1; then
        if [ -n "$remote_host" ]; then
          nh os switch ./ --ask --build-host "$remote_host" --use-substitutes "''${nh_args[@]}"
        else
          nh os switch ./ --ask "''${nh_args[@]}"
        fi
      else
        if [ -n "$remote_host" ]; then
          echo "nup: --remote is only supported for NixOS rebuilds" >&2
          exit 2
        fi
        nh home switch ./ --ask
      fi
    '')
  ];
}
