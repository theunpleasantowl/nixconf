# Home Manager module for Sidra (https://github.com/wimpysworld/sidra)
#
# Example:
#
#   imports = [ ./sidra.nix ];
#   programs.sidra = {
#     enable = true;
#     package = inputs.sidra.packages.${pkgs.stdenv.hostPlatform.system}.default;
#     settings = {
#       storefront = "us";
#       closeToTray.enabled = true;
#       discord.enabled = true;
#       notifications.enabled = false;
#       theme = "custom";
#     };
#     customTheme.dark = {
#       base = "#292d3e";
#       # ... all 12 colour keys
#     };
#   };
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.sidra;
  jsonFormat = pkgs.formats.json { };

  # Electron's userData dir on Linux: $XDG_CONFIG_HOME/Sidra (default ~/.config/Sidra)
  userDataDir = "${config.xdg.configHome}/Sidra";
  settingsFile = jsonFormat.generate "sidra-settings.json" cfg.settings;
  jq = lib.getExe pkgs.jq;
in
{
  options.programs.sidra = {
    enable = lib.mkEnableOption "Sidra, an Apple Music desktop client";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The Sidra package, e.g. from the upstream flake's packages output.";
    };

    settings = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      description = ''
        Keys to enforce in Sidra's config.json. They are deep-merged over the
        existing file on each activation, so keys you don't set (and runtime
        state such as the Last.fm session) are preserved.
      '';
      example = {
        closeToTray.enabled = true;
        theme = "custom";
      };
    };

    customTheme = lib.mkOption {
      type = lib.types.nullOr jsonFormat.type;
      default = null;
      description = "Contents of custom-theme.json. Needs a `dark` set with all 12 colour keys; `light` is optional.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # The theme file is only ever read by Sidra, so a read-only store symlink is fine.
    xdg.configFile."Sidra/custom-theme.json" = lib.mkIf (cfg.customTheme != null) {
      # The Sidra flake also provides this file (including a Stylix-generated
      # theme). Prefer the theme configured here when both modules are loaded.
      source = lib.mkForce (jsonFormat.generate "sidra-custom-theme.json" cfg.customTheme);
    };

    # config.json is rewritten by Sidra whenever a setting changes, so it must
    # stay a writable regular file. Merge our keys into it instead of symlinking.
    home.activation.sidraSettings = lib.mkIf (cfg.settings != { }) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        config_file="${userDataDir}/config.json"
        run mkdir -p "${userDataDir}"
        if [ -s "$config_file" ] && ${jq} -e . "$config_file" >/dev/null 2>&1; then
          tmp="$(mktemp)"
          ${jq} -s '.[0] * .[1]' "$config_file" ${settingsFile} > "$tmp"
          run install -m 0600 "$tmp" "$config_file"
          rm -f "$tmp"
        else
          run install -m 0600 ${settingsFile} "$config_file"
        fi
      ''
    );
  };
}
