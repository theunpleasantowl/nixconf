{ lib, ... }:
{
  programs.ghostty = {
    enable = true;

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    settings = {
      theme = "Embark";
      background-opacity = "0.95";
    };
  };
}
