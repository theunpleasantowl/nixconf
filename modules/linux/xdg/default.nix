{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.linux.desktop;

  desktops = {
    gnome = {
      enable = cfg.gnome.enable or false;
    };
    hyprland = {
      enable = cfg.hyprland.enable or false;
    };
    cosmic = {
      enable = cfg.cosmic.enable or false;
    };
    windowmaker = {
      enable = cfg.windowmaker.enable or false;
      needsXServer = true;
    };
  };

  anyEnabled = builtins.any (d: d.enable) (builtins.attrValues desktops);

  anyNeedsXServer = builtins.any (d: d.enable && (d.needsXServer or false)) (
    builtins.attrValues desktops
  );
in
{
  imports = [
    ./cosmic.nix
    ./gnome.nix
    ./hyprland.nix
    ./portals.nix
    ./programs.nix
    ./windowmaker.nix
  ];

  options.features.linux.desktop = {
    anyEnabled = lib.mkOption {
      type = lib.types.bool;
      readOnly = true;
      default = anyEnabled;
      description = "Whether any desktop environment is enabled";
    };

    utilities = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        helvum
        mpv
        wl-clipboard
      ];
      description = "Common desktop utilities to install";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf anyEnabled {
      hardware.graphics.enable = true;
      environment.systemPackages = cfg.utilities;
    })

    (lib.mkIf anyNeedsXServer {
      services.xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };
    })
  ];
}
