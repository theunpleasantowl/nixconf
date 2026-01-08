{pkgs, ...}: {
  programs = {
    anki = {
      enable = true;
      style = "native";
      addons = [
        pkgs.ankiAddons.anki-connect
        pkgs.ankiAddons.review-heatmap
      ];
    };

    keepassxc = {
      enable = true;

      settings = {
        General = {
          ConfigVersion = 2;
          UseAtomicSaves = true;
        };

        Browser = {
          Enabled = true;
          AlwaysAllowAccess = true;
          SearchInAllDatabases = true;
        };

        GUI = {
          AdvancedSettings = true;
          ApplicationTheme = "classic";
          HidePasswords = true;
          MinimizeOnClose = true;
          MinimizeOnStartup = true;
          MinimizeToTray = true;
          MonospaceNotes = true;
          ShowTrayIcon = true;
          TrayIconAppearance = "monochrome-light";
        };

        PasswordGenerator = {
          AdditionalChars = "";
          ExcludedChars = "";
          Length = 30;
        };

        SSHAgent.Enabled = true;
      };
    };

    joplin-desktop = {
      enable = true;
      sync.target = "file-system";
      extraConfig = {
        "editor.keyboardMode" = "vim";
      };
    };

    vesktop = {
      enable = true;
    };
  };

  home.packages = with pkgs; [
    cider
    delfin
    ferdium
    nextcloud-client
    thunderbird
  ];
}
