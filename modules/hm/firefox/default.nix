{
  wrapFirefox,
  cfg,
  self,
  lib,
  pkgs,
  ...
}:
wrapFirefox cfg.package {
  # for a list of avialable policies, see:
  #  https://github.com/mozilla/policy-templates/blob/master/README.md
  #  https://mozilla.github.io/policy-templates/
  extraPolicies = {
    AppAutoUpdate = false;
    CaptivePortal = false;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DisableFirefoxAccounts = true;
    DisableFormHistory = true;
    DisplayBookmarksToolbar = false;
    DontCheckDefaultBrowser = true;
    DisableSetDesktopBackground = true;
    PasswordManagerEnabled = false;
    PromptForDownloadLocation = true;
    SanitizeOnShutdown = cfg.security.sanitizeOnShutdown;

    FirefoxHome = {
      Pocket = false;
      Snippets = false;
    };

    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };

    Cookies = {
      Behavior = "accept";
      ExpireAtSessionEnd = false;
      Locked = false;
    };

    SearchEngines = {inherit (cfg.search) addEngines defaultSearchEngine removeEngines;};

    Bookmarks = cfg.bookmarks;

    ExtensionSettings = import ./extensions {inherit cfg self lib pkgs;};

    Preferences = import ./preferences.nix {inherit cfg;};
  };
}
