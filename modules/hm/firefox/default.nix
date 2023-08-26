{
  pkgs,
  cfg,
  lib,
  self,
  ...
}:
pkgs.wrapFirefox cfg.package {
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

    # FIXME: im gonna kms, it hurts my eyes
    ExtensionSettings = import ./extensions {inherit cfg self pkgs lib;};
    SearchEngines = import ./engines.nix {inherit cfg;};
    Bookmarks = lib.optionalAttrs (cfg.bookmarks != {}) cfg.bookmarks;

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
