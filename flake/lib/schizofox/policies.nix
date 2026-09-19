{
  cfg,
  pkgs,
  lib,
  darkreaderPkg,
}: {
  ## Features obsoleted by Nix
  AppAutoUpdate = false;

  ## Security / Privacy
  OverrideFirstRunPage = "";
  DisableTelemetry = !cfg.security.telemetry.enable;
  CaptivePortal = cfg.security.enableCaptivePortal;
  DisableFirefoxStudies = true;
  DisableFirefoxAccounts = !cfg.misc.firefoxSync;
  DisablePocket = true;
  DisableSetDesktopBackground = true;
  PromptForDownloadLocation = true;

  # These Mozilla enterprise policies lock the related settings off.
  AutofillAddressEnabled = cfg.security.autofill.addresses.enable;
  AutofillCreditCardEnabled = cfg.security.autofill.creditCards.enable;
  SearchSuggestEnabled = cfg.security.searchSuggestions.enable;

  # Tracking Protection
  EnableTrackingProtection = {
    Cryptomining = true;
    Fingerprinting = true;
    Locked = true;
    Value = true;
  };

  # Firefox Home
  FirefoxHome = {
    Search = true;
    Pocket = false;
    Snippets = false;
    TopSites = false;
    Highlights = false;
  };

  # How Schizofox should handle cookies
  Cookies = {
    Behavior = "accept";
    Locked = false;
  };

  # Attempt to support Smartcards (e.g. Nitrokeys) by using a proxy module.
  # This should provide an easier interface than `nixpkgs.config.firefox.smartcardSupport = true`
  SecurityDevices = {
    "PKCS#11 Proxy Module" = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
  };

  ## Shutdown sanitization behaviour
  DisableFormHistory = cfg.security.sanitizeOnShutdown.enable;
  SanitizeOnShutdown = cfg.security.sanitizeOnShutdown.enable;

  ## Irrelevant
  DontCheckDefaultBrowser = true;

  ## Misc
  NoDefaultBookmarks = true;
  OfferToSaveLogins = false;
  PasswordManagerEnabled = false;
  DisplayBookmarksToolbar = cfg.misc.displayBookmarksInToolbar;
  TranslateEnabled = cfg.misc.translate.enable;
  ShowHomeButton = cfg.misc.showHomeButton;

  # User Messaging
  UserMessaging = {
    ExtensionRecommendations = false;
    SkipOnboarding = true;
    MoreFromMozilla = false;
  };

  SearchEngines = {
    Add =
      cfg.search.addEngines
      ++ [
        {
          Name = "Searx";
          Description = "Searx";
          Alias = "!sx";
          Method = "GET";
          URLTemplate =
            if cfg.search.searxRandomizer.enable
            then "http://127.0.0.1:8000/search?q={searchTerms}"
            else cfg.search.searxQuery;
        }
      ];
    Default = cfg.search.defaultSearchEngine;
    Remove = cfg.search.removeEngines;
  };

  Bookmarks = cfg.misc.bookmarks;

  ExtensionSettings = import ./extensions.nix {inherit cfg lib pkgs darkreaderPkg;};
}
