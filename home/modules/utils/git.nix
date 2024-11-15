{...}: {
  home.shellAliases = {
    g = "git";
    gP = "git push";
    ga = "git add";
    gc = "git commit";
    gd = "git diff";
    gf = "git fetch";
    gl = "git log";
    gp = "git pull";
    gs = "git status";
    lg = "lazygit";
  };

  programs = {
    git = {
      enable = true;
      userName = "theunpleasantowl";
      userEmail = "theunpleasantowl@gmail.com";
      ignores = ["*~" "*.swp"];
      aliases = {
        ci = "commit";
      };
    };
    lazygit.enable = true;
  };
}
