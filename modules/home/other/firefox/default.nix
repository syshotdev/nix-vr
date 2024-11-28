{
  config,
  pkgs,
  ...
}: let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  programs = {
    firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        SanitizeOnShutdown = {
          Cache = false;
          Cookies = false;
          Downloads = true;
          FormData = true;
          History = false;
          Sessions = false;
          SiteSettings = false;
          OfflineApps = true;
          Locked = true;
        };
        SearchEngines = {
          PreventInstalls = true;
        };
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        Preferences = {
          "browser.theme.content-theme" = "dark";
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "browser.contentblocking.category" = {
            Value = "standard";
            Status = "locked";
          };
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          "browser.search.suggest.enabled" = lock-false;
          "browser.search.suggest.enabled.private" = lock-false;
          "browser.urlbar.suggest.searches" = lock-false;
          "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        };
        ExtensionSettings = with builtins; let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
          listToAttrs [
            (extension "ublock-origin" "uBlock0@raymondhill.net")
            (extension "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
            (extension "sponsorBlocker@ajay.app" "sponsorblock")
            (extension "nicothin-dark-theme" "{99c277af-d778-4a0b-9faa-b1d8165f0a55}")
            (extension "nicothin-space" "{22b0eca1-8c02-4c0d-a5d7-6604ddd9836e}")
          ];
      };
      profiles = {
        home = {
          id = 0;
          name = "home";
          isDefault = true;
        };
      };
    };
  };
}
