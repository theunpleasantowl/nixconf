{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "nup" ''
      set -e

      NIX_PATH="$HOME/.config/nixconf"
      cd "$NIX_PATH"

      nix flake update

      if command -v nixos-rebuild >/dev/null 2>&1; then
        nh os switch ./ --ask
      else
        nh home switch ./ --ask
      fi
    '')
  ];
}
