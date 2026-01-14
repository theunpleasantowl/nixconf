{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "golang"
      "nix"
      "rust"
      "toml"
    ];
    userSettings = {
      vim_mode = true;
    };
  };
  home.packages = with pkgs; [
    nil
    nixd
  ];
}
