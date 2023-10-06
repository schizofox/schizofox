self: {
  config,
  lib ? import ../../lib/extended-lib.nix pkgs.lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (lib) mkIf maintainers;

  cfg = config.programs.schizofox;

  mkNixPak = self.inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  mozillaConfigPath =
    if isDarwin
    then "Library/Application Support/Mozilla"
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
  meta.maintainers = with maintainers; [sioodmy NotAShelf];

  imports = [
    ./options.nix
  ];

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
      "${defaultProfile}/chrome/userContent.css".text = import ./firefox/userContent.nix;
    };

    home.packages = let
      pkg = pkgs.callPackage ./firefox {inherit profilesPath cfg self pkgs lib;};
    in
      if cfg.security.sandbox
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

                (sloth.concat [sloth.homeDir "/.mozilla"])
              ];

              bind.ro =
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
                ++ just' cursorTheme "${cursorTheme}";

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
  };
}
