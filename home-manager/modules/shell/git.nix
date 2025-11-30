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
      lfs.enable = true;
      settings = {
        user = {
          Name = "theunpleasantowl";
          Email = "theunpleasantowl@gmail.com";
        };
        aliases = {
          ci = "commit";
        };
      };
      ignores = [
        "*~"
        "*.swp"
      ];
    };
    lazygit.enable = true;
  };
}
