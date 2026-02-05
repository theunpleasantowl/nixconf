{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs = {
    anki = {
      enable = true;
      style = "native";
      addons = [
        pkgs.ankiAddons.anki-connect
        pkgs.ankiAddons.review-heatmap
      ];
      sync = lib.mkIf (config.sops.secrets ? anki-password) {
        autoSync = true;
        usernameFile = config.sops.secrets.anki-password.path;
        passwordFile = config.sops.secrets.anki-password.path;
      };
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
        "sync.2.path" = "${config.home.homeDirectory}/Nextcloud/Joplin";
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
        useQuickCss = true;
        plugins = {
          ClearURLs = {
            enabled = true;
          };
          Experiments = {
            enabled = true;
          };
          ExpressionCloner = {
            enabled = true;
          };
          FixYoutubeEmbeds = {
            enabled = true;
          };
          MessageLogger = {
            enabled = true;
          };
          PictureInPicture = {
            enabled = true;
          };
          SeeSummaries = {
            enabled = true;
          };
          TypingIndicator = {
            enabled = true;
          };
          TypingTweaks = {
            enabled = true;
          };
          ViewIcons = {
            enabled = true;
          };
          VoiceDownload = {
            enabled = true;
          };
          VoiceMessages = {
            enabled = true;
          };
          YoutubeAdblock = {
            enabled = true;
          };
        };
      };
    };
  };

  home.packages = with pkgs; [
    delfin
    ferdium
    nextcloud-client
    thunderbird
  ];
}
