{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.features.ollama;
  packageFor = {
    cuda = pkgs.ollama-cuda;
    rocm = pkgs.ollama-rocm;
    vulkan = pkgs.ollama-vulkan;
  };
in
{
  options.features.ollama = {
    enable = lib.mkEnableOption "Ollama for local LLM inference";

    acceleration = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "cuda"
          "rocm"
          "vulkan"
        ]
      );
      default = null;
      description = "GPU acceleration backend. null for CPU-only.";
    };

    models = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = "Preload models.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = if cfg.acceleration != null then packageFor.${cfg.acceleration} else pkgs.ollama;
      loadModels = cfg.models;
      openFirewall = false;
    };
  };
}
