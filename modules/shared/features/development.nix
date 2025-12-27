{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.development;
in {
  options.features.development = {
    enable = lib.mkEnableOption "development tools";

    languages = {
      rust = lib.mkEnableOption "Rust development";
      go = lib.mkEnableOption "Go development";
      python = lib.mkEnableOption "Python development";
      javascript = lib.mkEnableOption "JavaScript/TypeScript development";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        git
        git-extras
        lazygit
        neovim
        direnv
      ]
      ++ lib.optionals cfg.languages.rust [
        cargo
        rustc
        rust-analyzer
      ]
      ++ lib.optionals cfg.languages.go [
        go
        gopls
      ]
      ++ lib.optionals cfg.languages.python [
        python3
        python3Packages.pip
      ]
      ++ lib.optionals cfg.languages.javascript [
        nodejs
        yarn
      ];

    programs.direnv.enable = true;
  };
}
