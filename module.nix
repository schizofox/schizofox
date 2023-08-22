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

profilesIni = generators.toINI { } nameValuePair "Profile0" {
  Name = "schizo";
  Path = if isDarwin then "Profiles/schizo.default" else "schizo.default";
  IsRelative = 1;
  Default = 1;
} // {
      General = { StartWithLastProfile = 1; };
    };

    mozillaConfigPath =
    if isDarwin then "Library/Application Support/Mozilla" else ".mozilla";

  firefoxConfigPath = if isDarwin then
    "Library/Application Support/Firefox"
  else
    "${mozillaConfigPath}/firefox";

  profilesPath =
    if isDarwin then "${firefoxConfigPath}/Profiles" else firefoxConfigPath;

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
    home.file."${defaultProfile}/chrome/userChrome.css".text = import ./userChrome.nix { colros = with cfg; [ background-dark background foreground surface];};
    home.file."${defaultProfile}/chrome/userContent.css".source= ./userContent.css;
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
          SearchEngines = {
            Add = [
              {
                Name = "Sourcegraph/Nix";
                Description = "Sourcegraph nix search";
                Alias = "!snix";
                Method = "GET";
                URLTemplate = "https://sourcegraph.com/search?q=context:global+file:.nix%24+{searchTerms}&patternType=literal";
              }
              {
                Name = "Torrent search";
                Description = "Searching for legal linux isos ";
                # feds go away
                Alias = "!torrent";
                Method = "GET";
                URLTemplate = "https://librex.beparanoid.de/search.php?q={searchTerms}&t=3&p=0";
              }
              {
                Name = "Etherscan";
                Description = "Checking balances";
                Alias = "!eth";
                Method = "GET";
                URLTemplate = "https://etherscan.io/search?f=0&q={searchTerms}";
              }
              {
                Name = "Stackoverflow";
                Description = "Stealing code";
                Alias = "!so";
                Method = "GET";
                URLTemplate = "https://stackoverflow.com/search?q={searchTerms}";
              }
              {
                Name = "Wikipedia";
                Description = "Wikiless";
                Alias = "!wiki";
                Method = "GET";
                URLTemplate = "https://wikiless.org/w/index.php?search={searchTerms}title=Special%3ASearch&profile=default&fulltext=1";
              }
              {
                Name = "Crates.io";
                Description = "Rust crates";
                Alias = "!rs";
                Method = "GET";
                URLTemplate = "https://crates.io/search?q={searchTerms}";
              }
              {
                Name = "nixpkgs";
                Description = "Nixpkgs query";
                Alias = "!nix";
                Method = "GET";
                URLTemplate = "https://search.nixos.org/packages?&query={searchTerms}";
              }
              {
                Name = "youtube";
                Description = "not really";
                Alias = "!yt";
                Method = "GET";
                URLTemplate = "https://yt.femboy.hu/search?q={searchTerms}";
              }
              {
                Name = "Librex";
                Description = "A privacy respecting free as in freedom meta search engine for Google and popular torrent sites ";
                Alias = "!librex";
                Method = "GET";
                URLTemplate = "https://librex.beparanoid.de/search.php?q={searchTerms}&p=0&t=0";
              }
            ];
            Default = "Librex";
            # google glowies crying rn
            Remove = [
              "Google"
              "Bing"
              "Amazon.com"
              "eBay"
              "Twitter"
              "DuckDuckGo"
              "Wikipedia"
            ];
          };

          ExtensionSettings = let
            mkForceInstalled = extensions:
              builtins.mapAttrs
              (name: cfg: {installation_mode = "force_installed";} // cfg)
              extensions;
            reader = darkreader.override {
              background = cfg.background;
              foreground = cfg.foreground;
                    };
          in
            mkForceInstalled {
              "addon@darkreader.org".install_url = "file://${reader}/release/darkreader-firefox.xpi";
              "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/export-cookies-txt/latest.xpi";
              "{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
              "{b86e4813-687a-43e6-ab65-0bde4ab75758}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
              "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
              "{531906d3-e22f-4a6c-a102-8057b88a1a63}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/single-file/latest.xpi";
              "{c607c8df-14a7-4f28-894f-29e8722976af}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi";
              "skipredirect@sblask".install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
              "{b6129aa9-e45d-4280-aac8-3654e9d89d21}".install_url = "https://github.com/catppuccin/firefox/releases/download/old/catppuccin_frappe_pink.xpi";
              "smart-referer@meh.paranoid.pk".install_url = "https://github.com/catppuccin/firefox/releases/download/old/smart-referer.xpi";
            };

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

          Preferences = import ./config.nix { inherit cfg; };
        };
      })
    ];
  };
}
