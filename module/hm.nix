self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (lib) mkIf;

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
  imports = [./options.nix];
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
      "${defaultProfile}/chrome/userChrome.css".text = import ./firefox/userChrome.nix {inherit cfg lib;};

      # userContent
      "${defaultProfile}/chrome/userContent.css".text = import ./firefox/userContent.nix {inherit cfg lib;};
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
