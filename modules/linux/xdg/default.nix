{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.linux.desktop;

  desktops = {
    gnome = {
      enable = cfg.gnome.enable;
    };
    hyprland = {
      enable = cfg.hyprland.enable;
    };
    cosmic = {
      enable = cfg.cosmic.enable;
    };
    windowmaker = {
      enable = cfg.windowmaker.enable;
      needsXServer = true;
    };
  };

  anyEnabled = builtins.any (d: d.enable) (builtins.attrValues desktops);

  anyNeedsXServer = builtins.any (d: d.enable && (d.needsXServer or false)) (
    builtins.attrValues desktops
  );
in {
  imports = [
    ./cosmic.nix
    ./gnome.nix
    ./hyprland.nix
    ./portals.nix
    ./programs.nix
    ./windowmaker.nix
  ];

  options.features.linux.desktop = {
    utilities = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        firefox
        thunderbird
        mpv
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
        excludePackages = [pkgs.xterm];
      };
    })
  ];
}
