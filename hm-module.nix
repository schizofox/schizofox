self: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  cfg = config.programs.schizofox;

  darkreader = self.packages.${pkgs.stdenv.hostPlatform.system}.darkreader;

  profilesIni =
    generators.toINI {} nameValuePair "Profile0" {
      Name = "schizo";
      Path =
        if isDarwin
        then "Profiles/schizo.default"
        else "schizo.default";
      IsRelative = 1;
      Default = 1;
    }
    // {
      General = {StartWithLastProfile = 1;};
    };

  mozillaConfigPath =
    if isDarwin
    then "Library/Application Support/Mozilla"
    else ".mozilla";

  firefoxConfigPath =
    if isDarwin
    then "Library/Application Support/Firefox"
    else "${mozillaConfigPath}/firefox";

  profilesPath =
    if isDarwin
    then "${firefoxConfigPath}/Profiles"
    else firefoxConfigPath;

  defaultProfile = "${profilesPath}/schizo.default";
in {
  meta.maintainers = with maintainers; [sioodmy];
  options.programs.schizofox = {
    enable =
      mkEnableOption
      "Schizo firefox esr setup";
    userAgent = mkOption {
      type = types.str;
      example = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
      default = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101 Firefox/110.0";
      description = "Spoof user agent";
      # Some other user agnets
      # Mozilla/5.0 (X11; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
      # Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
      # Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
    };
    font = mkOption {
      type = types.str;
      example = "Lato";
      default = "Lexend";
      description = "Default firefox font";
    };
    background-darker = mkOption {
      type = types.str;
      example = "181825";
      default = "181825";
      description = "Darker background color";
    };
    background = mkOption {
      type = types.str;
      example = "1e1e2e";
      default = "1e1e2e";
      description = "Dark reader background color";
    };
    foreground = mkOption {
      type = types.str;
      example = "cdd6f4";
      default = "cdd6f4";
      description = "Dark reader text color";
    };

    defaultSearchEngine = mkOption {
      type = types.str;
      example = "DuckDuckGo";
      default = "Brave";
      description = "Default search engine";
    };

    removeEngines = mkOption {
      type = types.listOf types.str;
      example = ["Google"];
      default = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
      description = "List of default search engines to remove";
    };

    searxQuery = mkOption {
      type = types.str;
      example = "https://searx.be/search?q={searchTerms}&categories=general";
      default = "https://searx.be/search?q={searchTerms}&categories=general";
      description = "Search query for searx (or any other schizo search engine)";
    };

    sanitizeOnShutdown = mkOption {
      type = types.bool;
      default = true;
      description = "Clear cookies, history and other data on shutdown. Disabled on default, because it's quite annoying. Tip: use ctrl+i";
    };

    drmFix = mkOption {
      type = types.bool;
      default = false;
      description = "netflix no worky (just use torrents lmao)";
    };
    disableWebgl = mkOption {
      type = types.bool;
      default = false;
      description = "Disable WebGL, note that it brakes stuff and this aint tor browser";
    };
  };

  config = mkIf cfg.enable {
    home.file."${firefoxConfigPath}/profiles.ini".text = ''
      [Profile0]
      Name=default
      IsRelative=1
      Path=schizo.default
      Default=1

      [General]
      StartWithLastProfile=1
      Version=2
    '';
    home.file."${defaultProfile}/chrome/userChrome.css".text = with cfg; import ./userChrome.nix {inherit background-darker background foreground font;};
    home.file."${defaultProfile}/chrome/userContent.css".text = import ./userContent.nix {};

    home.packages = [
      (pkgs.wrapFirefox pkgs.firefox-esr-102-unwrapped {
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

          ExtensionSettings = import ./addons {inherit cfg darkreader;};
          SearchEngines = import ./searchengines.nix {inherit cfg;};

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

          SanitizeOnShutdown = let
            b = cfg.sanitizeOnShutdown;
          in {
            Cache = b;
            History = b;
            Cookies = b;
            Downloads = b;
            FormData = b;
            Sessions = b;
            OfflineApps = b;
            Locked = false;
          };
          Cookies.Locked = false;

          Preferences = import ./config.nix {inherit cfg;};
        };
      })
    ];
  };
}
