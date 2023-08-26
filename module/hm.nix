self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (lib) mkIf mkEnableOption mkOption mkPackageOption mdDoc maintainers types literalExpression;

  cfg = config.programs.schizofox;

  inherit (self.packages.${pkgs.system}) darkreader;

  mkNixPak = self.inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  mozillaConfigPath =
    if isDarwin
    then "Library/Application Support/Mozilla"
    else ".mozilla";

  firefoxConfigPath =
    if isDarwin
    then "Library/Application Support/Firefox"
    else mozillaConfigPath + "/firefox";

  profilesPath =
    if isDarwin
    then "${firefoxConfigPath}/Profiles"
    else firefoxConfigPath;

  defaultProfile = "${profilesPath}/schizo.default";
in {
  meta.maintainers = with maintainers; [sioodmy NotAShelf];

  options.programs.schizofox = {
    enable = mkEnableOption (mdDoc "Schizophrenic Firefox ESR setup for the delusional");
    package = mkPackageOption pkgs "firefox-esr-102-unwrapped" {
      example = "firefox-esr-115-unwrapped";
    };

    theme = {
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

      simplefox.enable = mkEnableOption ''
        A Userstyle theme for Firefox minimalist and Keyboard centered.
      '';
      darkreader = {
        enable = mkEnableOption ''
          Dark mode on all sites (patched to match overall theme)
        '';
        # TODO: patchDefaultColors bool option
      };

      extraCss = mkOption {
        type = types.str;
        example = ''
           body {
             background-color: red;
          }
        '';
        default = "";
        description = "Extra css for userChrome.css";
      };
    };

    bookmarks = mkOption {
      type = with types; listOf attrs;
      default = [];
      description = "List of bookmarks to add to your Schizofox configuration";
      example = literalExpression ''
        [
          {
            Title = "Example";
            URL = "https://example.com";
            Favicon = "https://example.com/favicon.ico";
            Placement = "toolbar";
            Folder = "FolderName";
          }
        ]
      '';
    };

    search = {
      defaultSearchEngine = mkOption {
        type = types.str;
        example = "DuckDuckGo";
        default = "Brave";
        description = "Default search engine";
      };

      addEngines = mkOption {
        type = with types; listOf attrs;
        default = import ./engineList.nix cfg;
        description = "List of search engines to add to your Schizofox configuration";
        example = literalExpression ''
          [
            {
              Name = "Etherscan";
              Description = "Checking balances";
              Alias = "!eth";
              Method = "GET";
              URLTemplate = "https://etherscan.io/search?f=0&q={searchTerms}";
            }
          ]
        '';
      };

      removeEngines = mkOption {
        type = with types; listOf str;
        default = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
        description = "List of default search engines to remove";
        example = literalExpression ["Google"];
      };

      searxUrl = mkOption {
        type = types.str;
        default = "https://searx.be";
        description = "Searx instance url";
        example = literalExpression "https://search.example.com";
      };

      searxQuery = mkOption {
        type = types.str;
        default = "${cfg.search.searxUrl}/search?q={searchTerms}&categories=general";
        description = "Search query for searx (or any other schizo search engine)";
        example = literalExpression "https://searx.be/search?q={searchTerms}&categories=general";
      };
    };

    security = {
      userAgent = mkOption {
        type = types.str;
        default = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101 Firefox/110.0";
        description = "Spoof user agent";
        example = literalExpression "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";

        /*
        Some other user agents
        Mozilla/5.0 (X11; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
        Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
        Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
        */
      };

      sanitizeOnShutdown = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Clear cookies, history and other data on shutdown.
          Disabled on default, because it's quite annoying. Tip: use ctrl+i";
        '';
      };

      sandbox = mkOption {
        type = types.bool;
        default = true;
        example = true;
        description = "Enable runtime sandboxing with NixPak";
      };
    };

    misc = {
      drmFix = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "netflix no worky (just use torrents lmao)";
      };

      disableWebgl = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Force WebGL to be disabled.
          Do note that it'll break plenty of websites that mess with the canvas (practically anything at this point)
        '';
      };

      startPageURL = mkOption {
        type = with types; nullOr str;
        default = null;
        example = literalExpression ''
          "file://${builtins.readFile ./startpage.html}"
        '';
        description = "An URL or an absolute path to your Firefox startpage";
      };
    };

    extensions = {
      extraExtensions = mkOption {
        type = types.attrs;
        default = {};
        description = "Extra extensions to be installed";
        example = literalExpression ''
          {
            "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
          }
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.file = {
      # profile config
      "${firefoxConfigPath}/profiles.ini".text = ''
        [Profile0]
        Name=default
        IsRelative=1
        Path=schizo.default
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';
      # userChrome content
      "${defaultProfile}/chrome/userChrome.css".text = with cfg; import ./firefox/userChrome.nix {inherit theme lib cfg;};

      # userContent
      "${defaultProfile}/chrome/userContent.css".text = import ./firefox/userContent.nix {};
    };

    home.packages = let
      pkg = pkgs.wrapFirefox cfg.package {
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
          ExtensionSettings = import ./extensions {inherit cfg darkreader pkgs lib;};
          SearchEngines = import ./config/engines.nix {inherit cfg;};
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

          Preferences = import ./config/preferences.nix {inherit cfg;};
        };
      };
    in
      if cfg.security.sandbox
      then [
        (mkNixPak {
          config = {sloth, ...}: rec {
            app.package = pkg;
            app.binPath = "bin/firefox";

            flatpak.appId = "org.mozilla.Firefox";

            dbus.policies = {
              "${flatpak.appId}" = "own";
              "${flatpak.appId}.*" = "own";
              "org.a11y.Bus" = "talk";
              "org.gnome.SessionManager" = "talk";
              "org.freedesktop.ScreenSaver" = "talk";
              "org.gtk.vfs.*" = "talk";
              "org.gtk.vfs" = "talk";
              "org.freedesktop.Notifications" = "talk";

              "org.freedesktop.portal.FileChooser" = "talk";
              "org.freedesktop.portal.Settings" = "talk";

              "org.mpris.MediaPlayer2.firefox.*" = "own";
              "org.mozilla.firefox.*" = "own";
              "org.mozilla.firefox_beta.*" = "own";

              "org.freedesktop.DBus" = "talk";
              "org.freedesktop.DBus.*" = "talk";
              "ca.desrt.dconf" = "talk";

              "org.freedesktop.portal.*" = "talk";

              "org.freedesktop.NetworkManager" = "talk";

              "org.freedesktop.FileManager1" = "talk";
            };

            gpu.enable = true;
            gpu.provider = "bundle";
            fonts.enable = true;
            locale.enable = true;

            etc.sslCertificates.enable = true;

            bubblewrap = let
              envSuffix = envKey: sloth.concat' (sloth.env envKey);
            in {
              network = true;

              bind.rw = [
                (sloth.concat' sloth.xdgCacheHome "/fontconfig")
                (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")
                (sloth.concat [
                  (sloth.env "XDG_RUNTIME_DIR")
                  "/"
                  (sloth.env "WAYLAND_DISPLAY")
                ])

                (envSuffix "XDG_RUNTIME_DIR" "/at-spi/bus")
                (envSuffix "XDG_RUNTIME_DIR" "/gvfsd")
                (envSuffix "XDG_RUNTIME_DIR" "/pulse")
                (envSuffix "XDG_RUNTIME_DIR" "/doc")
                (envSuffix "XDG_RUNTIME_DIR" "/dconf")

                (sloth.concat [sloth.homeDir "/.mozilla"])
              ];

              bind.ro = [
                "/etc/resolv.conf"

                (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
                (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
                (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
                (sloth.concat' sloth.xdgConfigHome "/dconf")
                "/etc/localtime"

                "/sys/bus/pci"

                "${
                  config.home.pointerCursor.package
                }"

                [
                  "${pkg}/lib/firefox"
                  "/app/etc/firefox"
                ]
              ];

              env = {
                XDG_DATA_DIRS = lib.makeSearchPath "share" [
                  config.gtk.iconTheme.package
                  config.gtk.theme.package
                  config.home.pointerCursor.package
                  pkgs.shared-mime-info
                ];
                XCURSOR_PATH = lib.concatStringsSep ":" [
                  "${config.home.pointerCursor.package}/share/icons"
                  "${config.home.pointerCursor.package}/share/pixmaps"
                ];
              };
            };
          };
        })
        .config
        .env
      ]
      else [pkg];
  };
}
