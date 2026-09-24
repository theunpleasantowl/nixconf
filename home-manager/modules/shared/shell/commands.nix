{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "nup" ''
      set -e

      NIX_PATH="$HOME/.config/nixconf"
      cd "$NIX_PATH"

      if command -v nixos-rebuild >/dev/null 2>&1; then
        nix flake update
        nh os switch ./ --ask "$@"
      else
        nix flake update
        nh home switch ./ --ask
      fi
    '')
  ];
}
