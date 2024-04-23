{
  fetchurl,
  makeDesktopItem,
  wrapFirefox,
  profilesPath,
  cfg,
  self,
  pkgs,
  lib,
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
    (wrapFirefox cfg.package {
      # for a list of avialable policies, see:
      #  https://github.com/mozilla/policy-templates/blob/master/README.md
      #  https://mozilla.github.io/policy-templates/
      extraPolicies = {
        OverrideFirstRunPage = "";
        DisableTelemetry = true;
        AppAutoUpdate = false;
        CaptivePortal = cfg.security.enableCaptivePortal;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = !cfg.misc.firefoxSync;
        DisablePocket = true;
        DisableFormHistory = true;
        DisplayBookmarksToolbar = cfg.misc.displayBookmarksInToolbar;
        DontCheckDefaultBrowser = true;
        DisableSetDesktopBackground = true;
        PasswordManagerEnabled = false;
        PromptForDownloadLocation = true;
        SanitizeOnShutdown = cfg.security.sanitizeOnShutdown;

        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;

        EnableTrackingProtection = {
          Cryptomining = true;
          Fingerprinting = true;
          Locked = true;
          Value = true;
        };

        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
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
          makeWrapper $out/bin/firefox $out/bin/schizofox
        '';
    });
in
  wrappedFox
