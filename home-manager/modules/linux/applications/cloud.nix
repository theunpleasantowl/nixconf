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
      settings = {
        checkUpdates = false;
        discordBranch = "stable";
        hardwareAcceleration = true;
        autoStartMinimized = true;
        clickTrayToShowHide = true;
        minimizeToTray = true;
      };
      vencord.settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;
        transparent = true;
        plugins = {
          clearURLs = {
            enable = true;
          };
          experiments = {
            enable = true;
          };
          expressionCloner = {
            enable = true;
          };
          fixYoutubeEmbeds = {
            enable = true;
          };
          messageLogger = {
            enable = true;
          };
          pictureInPicture = {
            enable = true;
          };
          seeSummaries = {
            enable = true;
          };
          typingIndicator = {
            enable = true;
          };
          typingTweaks = {
            enable = true;
          };
          voiceDownload = {
            enable = true;
          };
          voiceMessages = {
            enable = true;
          };
          youtubeAdblock = {
            enable = true;
          };
        };
        cloud = {
          authenticated = true;
          settingsSync = true;
        };
      };
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
