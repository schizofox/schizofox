self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) toJSON isBool isInt isString;
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStrings hasInfix;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) optionals;

  userPrefValue = pref:
    toJSON (
      if isBool pref || isInt pref || isString pref
      then pref
      else toJSON pref
    );

  # https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#L46
  mkUserJs = prefs: extra: let
    prefs' = prefs // extra;
  in ''
    // Generated by Schizofox
    ${concatStrings (mapAttrsToList (name: value: ''
        user_pref("${name}", ${userPrefValue value});
      '')
      prefs')}
  '';

  cfg = config.programs.schizofox;

  mkNixPak = self.inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  mozillaConfigPath =
    if isDarwin
    then "Library/Application Support/Mozilla"
    else if cfg.misc.customMozillaFolder.enable
    then "${config.home.homeDirectory}${cfg.misc.customMozillaFolder.path}"
    else "${config.home.homeDirectory}/.mozilla";

  firefoxConfigPath =
    if isDarwin
    then "Library/Application Support/Firefox"
    else mozillaConfigPath + "/firefox";

  profilesPath =
    if isDarwin
    then "${firefoxConfigPath}/Profiles"
    else firefoxConfigPath;

  maybeTheme = opt: lib.findFirst builtins.isNull opt.package [opt opt.package];

  just' = v: lib.optional (v != null);

  just = v: just' v v;

  gtkTheme = maybeTheme config.gtk.theme;

  iconTheme = maybeTheme config.gtk.iconTheme;

  cursorTheme = maybeTheme config.home.pointerCursor;

  defaultProfile = "${profilesPath}/schizo.default";
in {
  meta.maintainers = with lib.maintainers; [sioodmy NotAShelf];
  imports = [./options];
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasInfix "esr" cfg.package.version;
        message = ''
          The package provided to 'programs.schizofox.package' is not an ESR release of Firefox: ${cfg.package.pname}

          For policies to function as intended, you must an ESR release of Firefox. If you think this is a mistake, please open an issue.
        '';
      }
    ];

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
      "${defaultProfile}/chrome/userChrome.css".text = import ./firefox/userChrome.nix {inherit pkgs lib cfg self;};

      # userContent
      "${defaultProfile}/chrome/userContent.css".text = import ./firefox/userContent.nix {inherit pkgs lib cfg self;};

      # user.js
      "${defaultProfile}/user.js".text = mkUserJs (import ./firefox/preferences {inherit cfg lib;}) cfg.settings;
    };

    home.packages = let
      pkg = pkgs.callPackage ./firefox {inherit profilesPath cfg self pkgs lib;};
    in
      if cfg.security.sandbox.enable
      then [
        (mkNixPak {
          config = {sloth, ...}: let
            appId = "org.mozilla.Firefox";
          in {
            flatpak = {
              inherit appId;
            };
            app.package = pkg;
            app.binPath = "bin/schizofox";

            dbus.policies = {
              "${appId}" = "own";
              "${appId}.*" = "own";
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
                  (sloth.envOr "WAYLAND_DISPLAY" "no")
                ])
                "/tmp/.X11-unix"
                (sloth.envOr "XAUTHORITY" "/no-xauth")

                (envSuffix "XDG_RUNTIME_DIR" "/at-spi/bus")
                (envSuffix "XDG_RUNTIME_DIR" "/gvfsd")
                (envSuffix "XDG_RUNTIME_DIR" "/pulse")
                (envSuffix "XDG_RUNTIME_DIR" "/doc")
                (envSuffix "XDG_RUNTIME_DIR" "/dconf")

                (
                  if cfg.misc.customMozillaFolder.enable
                  then [
                    (sloth.concat' sloth.homeDir cfg.misc.customMozillaFolder.path)
                    (sloth.concat' sloth.homeDir "/.mozilla")
                  ]
                  else "${config.home.homeDirectory}/.mozilla"
                )
              ];

              bind.ro = builtins.concatLists [
                [
                  "/etc/resolv.conf"

                  (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
                  (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
                  (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
                  (sloth.concat' sloth.xdgConfigHome "/dconf")
                  "/etc/localtime"

                  "/sys/bus/pci"

                  [
                    "${pkg}/lib/firefox"
                    "/app/etc/firefox"
                  ]
                ]

                (just' cursorTheme "${cursorTheme}")

                # Additional Read-only paths specified by the user
                cfg.security.sandbox.extraBinds
                (optionals cfg.security.sandbox.allowFontPaths ["/etc/fonts"])
              ];

              env = {
                XDG_DATA_DIRS = lib.makeSearchPath "share" ([
                    pkgs.shared-mime-info
                  ]
                  ++ just iconTheme
                  ++ just gtkTheme
                  ++ just cursorTheme);
                XCURSOR_PATH = lib.mkIf (cursorTheme != null) (lib.concatStringsSep ":" [
                  "${cursorTheme}/share/icons"
                  "${cursorTheme}/share/pixmaps"
                ]);
              };
            };
          };
        })
        .config
        .env
      ]
      else [pkg];

    # Start a local Systemd service for responding to requests with a random
    # Searxng instance to handle the request. Searxng instances will be selected
    # from the list of instances passed to `search.searxRandomizer.instances`
    systemd.user.services.searx-randomizer = mkIf cfg.search.searxRandomizer.enable {
      Unit = {
        Description = "Searx instance randomizer";
        Documentation = "https://github.com/schizofox/searx-randomizer";
      };

      Install.WantedBy = ["graphical-session.target"];

      Service = {
        Environment = let
          engines = toJSON cfg.search.searxRandomizer.instances;
        in ["SEARX_INSTANCES=${pkgs.writeText "engines.json" engines}"];
        ExecStart = "${self.inputs.searx-randomizer.packages.${pkgs.system}.default}/bin/searx-randomizer";
        Restart = "always";
        RestartSec = 12;
      };
    };
  };
}
