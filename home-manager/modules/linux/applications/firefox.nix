{
  config,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

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
      };

      search = {
        force = true;
        default = "ddg";
      };
    };
  };
}
