{
  config,
  lib,
  pkgs,
  self,
  usingNixosModule ? false,
  cursorTheme,
  iconTheme,
  gtkTheme,
  ...
}: let
  inherit (builtins) toJSON isBool isInt isString;
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
  inherit (lib.strings) concatStrings;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) optionals;

  # can use lockPref here if we want to prevent users from modifying values
  prefString =
    if usingNixosModule
    then "pref"
    else "user_pref";
  userPrefValue = pref:
    toJSON (
      if isBool pref || isInt pref || isString pref
      then pref
      else toJSON pref
    );

  # https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#L46
  mkUserJs = prefs: extra: let
    prefs' = prefs // extra;
    userChrome = pkgs.writeTextFile {
      name = "schizofox-userchrome";
      text = files."userChrome.css".text;
    };
    userContent = pkgs.writeTextFile {
      name = "schizofox-usercontent";
      text = files."userContent.css".text;
    };
  in ''
    // Autoconfig logic originally from PostmarketOS mobile-config-firefox
    // Copyright 2022 Arnaud Ferraris, Oliver Smith
    // SPDX-License-Identifier: MPL-2.0

    const {classes: Cc, interfaces: Ci, utils: Cu} = Components;
    Cu.import("resource://gre/modules/FileUtils.jsm");
    var updated = false;

    // Create nsiFile objects
    var chromeDir = Services.dirsvc.get("ProfD", Ci.nsIFile);
    chromeDir.append("chrome");

    // XP_UNIX forces symlinks to be resolved when copying
    // so we are just going to normal copy from nix store
    // <https://bugzilla.mozilla.org/show_bug.cgi?id=480726>
    var userChrome = new FileUtils.File("${userChrome}");
    var userContent = new FileUtils.File("${userContent}");

    if (!chromeDir.exists()) {
        chromeDir.create(Ci.nsIFile.DIRECTORY_TYPE, FileUtils.PERMS_DIRECTORY);
    }

    var chromeFile = chromeDir.clone();
    chromeFile.append("userChrome.css");
    if (!chromeFile.exists()) {
        userChrome.copyTo(chromeDir, "userChrome.css");
        updated = true;
    }

    var contentFile = chromeDir.clone();
    contentFile.append("userContent.css");
    if (!contentFile.exists()) {
        userContent.copyTo(chromeDir, "userContent.css");
        updated = true;
    }

    // Ensure the added css gets applied to this session
    if (updated === true) {
        var appStartup = Cc["@mozilla.org/toolkit/app-startup;1"].getService(Ci.nsIAppStartup);
        appStartup.quit(Ci.nsIAppStartup.eForceQuit | Ci.nsIAppStartup.eRestart);
    }

    // Generated by Schizofox
    ${concatStrings (
      mapAttrsToList (name: value: ''
        ${prefString}("${name}", ${userPrefValue value});
      '')
      prefs'
    )}
  '';

  cfg = config.programs.schizofox;

  mkNixPak = self.inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  just' = v: lib.optional (v != null);

  just = v: just' v v;

  files = {
    # profile config
    "profiles.ini".text = ''
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
    "userChrome.css".text = import ./firefox/userChrome.nix {inherit pkgs lib cfg self;};

    # userContent
    "userContent.css".text = import ./firefox/userContent.nix {inherit pkgs lib cfg self;};

    # user.js
    "user.js".text = mkUserJs (import ./firefox/preferences {inherit cfg lib;}) cfg.settings;
  };

  searx-randomizer-unit = {
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

  packages = let
    pkg = pkgs.callPackage ../common/firefox {inherit cfg self pkgs lib files usingNixosModule;};
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

              (sloth.concat [
                sloth.homeDir
                "/.mozilla"
              ])
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
              XDG_DATA_DIRS = lib.makeSearchPath "share" (
                [
                  pkgs.shared-mime-info
                ]
                ++ just iconTheme
                ++ just gtkTheme
                ++ just cursorTheme
              );
              XCURSOR_PATH = lib.mkIf (cursorTheme != null) (
                lib.concatStringsSep ":" [
                  "${cursorTheme}/share/icons"
                  "${cursorTheme}/share/pixmaps"
                ]
              );
            };
          };
        };
      })
      .config
      .env
    ]
    else [pkg];
in {
  inherit files;
  inherit searx-randomizer-unit;
  inherit packages;
}
