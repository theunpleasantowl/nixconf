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
    numCtx = lib.mkOption {
      type = lib.types.int;
      default = 16384;
      description = "Context window size. 16384 minimum for reliable tool-calling.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = if cfg.acceleration != null then packageFor.${cfg.acceleration} else pkgs.ollama;
      loadModels = cfg.models;
      openFirewall = false;
      environmentVariables.OLLAMA_NUM_CTX = toString cfg.numCtx;
    };
  };
}
