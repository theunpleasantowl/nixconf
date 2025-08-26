{pkgs, ...}: {
  programs.zsh.enable = true;

  users.users.hibiki = {
    isNormalUser = true;
    description = "hibiki";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
}
