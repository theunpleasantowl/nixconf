{
  programs.sidra = {
    enable = true;

    settings = {
      theme = "custom";
      player = {
        service = "music";
        musicStartPage = "new";
        classicalStartPage = "browse";
      };
      discord.richPresence.enable = true;
      notifications.enable = false;
      closeToTray.enable = true;
      autoUpdate.enable = true;
    };
  };
}
