{
  self,
  pkgs,
  lib,
  # Dependencies
  makeDesktopItem,
  wrapFirefox,
  # Customizability
  cfg,
  files,
  usingNixosModule,
  ...
}: let
  logo = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/schizofox/assets/main/logo/logo.png";
    sha256 = "1wjzivdmppbzrwdxhza5dzzljl3z59vfgggxim9xjb2rzr0wqyyf";
  };

  desktopItem = makeDesktopItem {
    name = "Schizofox";
    desktopName = "Schizofox";
    genericName = "Web Browser";
    exec =
      if cfg.security.wrapWithProxychains
      then "proxychains4 schizofox %U"
      else "schizofox %U";
    icon = "${logo}";
    terminal = false;
    categories = ["Network" "WebBrowser"];
    mimeTypes = ["text/html" "text/xml"];
  };

  wrappedFox =
    wrapFirefox cfg.package {
      # For a list of available policies, or explanations of policies set below, please see:
      #  <https://github.com/mozilla/policy-templates/blob/master/README.md>
      #  <https://mozilla.github.io/policy-templates>
      # Enterprise policies override all userjs preferences.
      extraPolicies = {
        ## Features obsoleted by Nix
        AppAutoUpdate = false;

        ## Security / Privacy
        OverrideFirstRunPage = "";
        DisableTelemetry = true;
        CaptivePortal = cfg.security.enableCaptivePortal;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = !cfg.misc.firefoxSync;
        DisablePocket = true;
        DisableSetDesktopBackground = true;
        PromptForDownloadLocation = true;

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

        ExtensionSettings = import ./extensions {inherit cfg self lib pkgs;};
      };
    }
    // lib.optionalAttrs usingNixosModule {
      extraPrefs = files."user.js".text;
    };

  finalPackage = wrappedFox.overrideAttrs (old: {
    buildCommand =
      (
        # Shouldn't ever happen...
        old.buildCommand or ""
      )
      + ''
        rm -rf $out/share/applications/*
        install -D ${desktopItem}/share/applications/Schizofox.desktop $out/share/applications/Schizofox.desktop
        makeWrapper $out/bin/firefox $out/bin/schizofox
      '';
  });
in
  finalPackage
