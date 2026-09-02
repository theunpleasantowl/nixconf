{
  osConfig,
  lib,
  ...
}:
let
  ollamaCfg = osConfig.features.ollama or { enable = false; };
  ollamaEnabled = ollamaCfg.enable or false;
  ollamaModels = ollamaCfg.models or [ "qwen2.5-coder:14b-instruct-q4_K_M" ];
in
{
  programs.opencode = lib.mkIf ollamaEnabled {
    enable = true;

    settings = {
      provider.ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama (local)";
        options.baseURL = "http://localhost:11434/v1";
        models = lib.listToAttrs (
          map (m: {
            name = m;
            value.tools = true;
          }) ollamaModels
        );
      };
    };
  };
}
