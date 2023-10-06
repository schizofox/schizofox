{
  fetchurl,
  makeDesktopItem,
  wrapFirefox,
  profilesPath,
  callPackage,
  cfg,
  self,
  ...
}: let
  desktopItem =
    makeDesktopItem
    {
      name = "Schizofox";
      desktopName = "Schizofox";
      genericName = "Web Browser";
      exec = "schizofox %U";
      icon = fetchurl {
        url = "https://raw.githubusercontent.com/schizofox/assets/main/logo/logo.png";
        hash = "sha256-znvMQf5ZLNlTjf2953Yqf1BJ/29Ffdgbz3/dW9uOX/I=";
      };

      terminal = false;
      categories = ["Application" "Network" "WebBrowser"];
      mimeTypes = ["text/html" "text/xml"];
    };
in
  (wrapFirefox cfg.package {
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

      ExtensionSettings = callPackage ./extensions {inherit cfg self;};
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

      Preferences = import ./preferences.nix cfg;
    };
  })
  .overrideAttrs (old: {
    buildCommand =
      (
        old.buildCommand or ""
        /*
        shouldn't ever happen...
        */
      )
      + ''
        rm -rf $out/share/applications/*
        install -D ${desktopItem}/share/applications/Schizofox.desktop $out/share/applications/Schizofox.desktop

        makeWrapper $out/bin/firefox $out/bin/schizofox \
          --add-flags '-Profile ${profilesPath}/schizo.default'

      '';
  })
