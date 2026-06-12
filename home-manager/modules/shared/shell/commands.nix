{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "nup" ''
      set -e

      remote_host=""
      nh_args=()

      usage() {
        echo "Usage: nup [--remote HOSTNAME] [NH_ARGS...]"
      }

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
            if [ -z "$remote_host" ]; then
              echo "nup: --remote requires a host name" >&2
              exit 2
            fi
            shift
            ;;
          -h|--help)
            usage
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

      if [ -n "$remote_host" ]; then
        if ! command -v nixos-rebuild >/dev/null 2>&1; then
          echo "nup: --remote is only supported for NixOS rebuilds" >&2
          exit 2
        fi

        if ! ssh "$remote_host" true; then
          echo "nup: failed to connect to remote host '$remote_host'" >&2
          exit 1
        fi

        target_hostname="$(hostname)"
        for ((i = 0; i < ''${#nh_args[@]}; i++)); do
          case "''${nh_args[$i]}" in
            -H|--hostname)
              next_index=$((i + 1))
              if [ "$next_index" -ge "''${#nh_args[@]}" ]; then
                echo "nup: ''${nh_args[$i]} requires a hostname" >&2
                exit 2
              fi
              target_hostname="''${nh_args[$next_index]}"
              ;;
            --hostname=*)
              target_hostname="''${nh_args[$i]#--hostname=}"
              if [ -z "$target_hostname" ]; then
                echo "nup: --hostname requires a hostname" >&2
                exit 2
              fi
              ;;
          esac
        done

        remote_store_path="$(
          ssh "$remote_host" bash -s -- "$target_hostname" <<'REMOTE_NUP'
set -e

target_hostname="$1"
NIX_PATH="$HOME/.config/nixconf"

if [ ! -d "$NIX_PATH/.git" ]; then
  echo "nup: remote repo is missing at $NIX_PATH" >&2
  exit 1
fi

cd "$NIX_PATH"

branch="$(git branch --show-current)"
if [ "$branch" != "devel" ]; then
  echo "nup: remote repo must be on branch 'devel' (currently '$branch')" >&2
  exit 1
fi

if ! git diff --quiet; then
  echo "nup: remote repo has unstaged changes" >&2
  git status --short >&2
  exit 1
fi

if [ -n "$(git ls-files --others --exclude-standard)" ]; then
  echo "nup: remote repo has untracked files" >&2
  git status --short >&2
  exit 1
fi

echo "nup: building .#nixosConfigurations.$target_hostname.config.system.build.toplevel on remote host $(hostname) from $NIX_PATH" >&2
nix flake update

nix build \
  ".#nixosConfigurations.$target_hostname.config.system.build.toplevel" \
  --no-link \
  --print-out-paths
REMOTE_NUP
        )"

        echo "nup: copying remote build result $remote_store_path from $remote_host"
        if ! nix copy --from "ssh://$remote_host" "$remote_store_path"; then
          echo "nup: failed to copy the remote build result from '$remote_host'" >&2
          echo "nup: if Nix rejected unsigned paths, add this user or @wheel to nix.settings.trusted-users on this host and switch to that configuration" >&2
          exit 1
        fi
        nh os switch "$remote_store_path" --ask "''${nh_args[@]}"
      elif command -v nixos-rebuild >/dev/null 2>&1; then
        nix flake update
        nh os switch ./ --ask "''${nh_args[@]}"
      else
        nix flake update
        nh home switch ./ --ask
      fi
    '')
  ];
}
