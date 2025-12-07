{
  config,
  pkgs,
  lib,
  ...
}: let
  systemPkgs =
    if config ? environment && config.environment ? systemPackages
    then config.environment.systemPackages
    else [];

  ghosttyPkg =
    if pkgs.stdenv.isDarwin
    then pkgs.ghostty-bin
    else pkgs.ghostty;
in {
  programs.ghostty = {
    enable = true;

    # Only install if not already in the NixOS system
    package = lib.mkIf (!builtins.elem ghosttyPkg systemPkgs) ghosttyPkg;

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      theme = "Embark";
      background-opacity = "0.95";
    };
  };
}
