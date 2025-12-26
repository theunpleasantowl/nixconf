{config, ...}: {
  # Nix Helper
  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/.config/nixconf";
  };
}
