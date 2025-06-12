{pkgs, ...}: {
  system.stateVersion = 4;

  networking.hostName = "eva";

  programs.zsh.enable = true;
  programs.fish.enable = false;
  environment.shells = [pkgs.zsh];

  system.primaryUser = "icarus";
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    trackpad.Clicking = true;
  };

  fonts.packages = with pkgs; [
    fontconfig
    jetbrains-mono
    fira-code
    fira-code-symbols
  ];

  users.users.icarus = {
    home = "/Users/icarus";
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
    gnupg
  ];

  nixpkgs.config.allowUnfree = true;

  # Enable nix flakes & experimental features
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
