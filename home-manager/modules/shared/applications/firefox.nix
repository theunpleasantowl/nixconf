{...}: let
  profile = "default";
in {
  programs.firefox = {
    enable = true;

    profiles.${profile} = {
      id = 0;
      name = profile;
      isDefault = true;

      extensions = {
        force = true;
      };

      settings = {
        # Privacy
        "browser.contentblocking.category" = "strict";
        "browser.formfill.enable" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.search.suggest.enabled" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.suggest.searches" = false;
        "extensions.pocket.enabled" = false;

        # Telemetry
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;

        # Portal
        "widget.use-xdg-desktop-portal.file-picker" = 1;

        # UI
        "browser.uidensity" = 1;
        "browser.uiCustomization.navBarWhenVerticalTabs" = [
          "firefox-view-button"
          "back-button"
          "forward-button"
          "stop-reload-button"
          "customizableui-special-spring1"
          "vertical-spacer"
          "urlbar-container"
          "customizableui-special-spring2"
          "downloads-button"
          "ublock0_raymondhill_net-browser-action"
          "addon_darkreader_org-browser-action"
          "private-bookmarks_rharel-browser-action"
          "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
          "_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action"
          "keepassxc-browser_keepassxc_org-browser-action"
          "unified-extensions-button"
          "fxa-toolbar-menu-button"
        ];
      };

      search = {
        force = true;
        default = "ddg";
      };
    };
  };

  stylix.targets.firefox = {
    colorTheme.enable = true;
    firefoxGnomeTheme.enable = true;
    profileNames = [profile];
  };
}
