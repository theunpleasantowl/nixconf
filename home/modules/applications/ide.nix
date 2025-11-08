{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      bbenoist.nix
      esbenp.prettier-vscode
      tamasfe.even-better-toml
      yzhang.markdown-all-in-one
    ];
  };
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
}
