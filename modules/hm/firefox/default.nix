{
  wrapFirefox,
  cfg,
  self,
  lib,
  pkgs,
  ...
}:
wrapFirefox cfg.package {
  # see https://github.com/mozilla/policy-templates/blob/master/README.md
  extraPolicies = {
    CaptivePortal = false;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DisableFirefoxAccounts = true;
    DisableFormHistory = true;
    DisplayBookmarksToolbar = false;
    DontCheckDefaultBrowser = true;

    ExtensionSettings = import ./extensions {inherit cfg self lib pkgs;};

    SearchEngines = {
      Add = cfg.search.addEngines;
      Default = cfg.search.defaultSearchEngine;
      Remove = cfg.search.removeEngines;
    };
    Bookmarks = cfg.bookmarks;

    FirefoxHome = {
      Pocket = false;
      Snippets = false;
    };

    PasswordManagerEnabled = false;
    PromptForDownloadLocation = true;

    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };

    DisableSetDesktopBackground = true;
    SanitizeOnShutdown = cfg.security.sanitizeOnShutdown;

    Cookies = {
      Behavior = "accept";
      ExpireAtSessionEnd = false;
      Locked = false;
    };

    Preferences = import ./preferences.nix {inherit cfg;};
  };
}
