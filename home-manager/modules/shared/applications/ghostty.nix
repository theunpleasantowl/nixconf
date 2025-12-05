{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      theme = "Abernathy";
      background-opacity = "0.95";
    };
  };
}
