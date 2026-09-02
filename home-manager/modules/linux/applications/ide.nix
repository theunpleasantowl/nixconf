{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.features.ide;
in
{
  options.features.ide = {
    enable = lib.mkEnableOption "IDE and editor tools";

    zed = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable Zed editor with language extensions";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = lib.mkIf cfg.zed {
      enable = true;
      extensions = [
        "golang"
        "nix"
        "rust"
        "toml"
      ];
      userSettings = {
        vim_mode = true;
      };
    };

    home.packages = lib.optionals cfg.zed (
      with pkgs;
      [
        nil
        nixd
      ]
    );
  };
}
