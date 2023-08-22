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

    surface = mkOption {
      type = types.str;
      example = "313244";
      default = "313244";
      description = "Dark reader secondary background color";
    };

    defaultSearchEngine = mkOption {
      type = types.str;
      example = "DuckDuckGo";
      default = "DuckDuckGo";
      description = "Default search engine";
    };

    removeEngines = mkOption {
      type = types.listOf types.str;
      example = ["Google"];
      default = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
      description = "List of default search engines to remove";
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
    home.file."${defaultProfile}/chrome/userChrome.css".text = import ./userChrome.nix {colros = with cfg; [background-dark background foreground surface];};
    home.file."${defaultProfile}/chrome/userContent.css".source = ./userContent.css;
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
          DisplayBookmarksToolbar = true;
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

          SanitizeOnShutdown = {
            Cache = true;
            History = true;
            Cookies = true;
            Downloads = true;
            FormData = true;
            Sessions = true;
            OfflineApps = true;
          };

          Preferences = import ./config.nix {inherit cfg;};
        };
      })
    ];
  };
}
