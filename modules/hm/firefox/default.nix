{
  fetchurl,
  makeDesktopItem,
  wrapFirefox,
  profilesPath,
  cfg,
  self,
  pkgs,
  callPackage,
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
    exec = "schizofox %U";
    icon = "${logo}";
    terminal = false;
    categories = ["Application" "Network" "WebBrowser"];
    mimeTypes = ["text/html" "text/xml"];
  };

  wrappedFox =
    (wrapFirefox cfg.package {
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

        Preferences = import ./preferences {inherit cfg;};
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
    });
in
  wrappedFox
