{
  self,
  inputs,
}: {
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasInfix;

  cfg = config.programs.schizofox;

  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
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
  schizofox = (pkgs.callPackage self.lib.mkSchizofox {}) (
    (import ../../pkgs/schizofox/from-module.nix {inherit cfg pkgs lib;})
    // {
      firefox-unwrapped = cfg.package;
      profilePrefName = "user_pref";
      cursorTheme = maybeTheme config.home.pointerCursor;
      iconTheme = maybeTheme config.gtk.iconTheme;
      gtkTheme = maybeTheme config.gtk.theme;
      nixpakLib = inputs.nixpak.lib.nixpak {
        inherit (pkgs) lib;
        inherit pkgs;
      };
    }
  );

  defaultProfile = "${profilesPath}/schizo.default";
in {
  meta.maintainers = with lib.maintainers; [NotAShelf];
  imports = [self.lib.schizofoxOptions];
  config = mkIf cfg.enable {
    home = {
      packages = [schizofox.package];
      file = {
        "${firefoxConfigPath}/profiles.ini".text = schizofox.files."profiles.ini".text;
        "${defaultProfile}/chrome/userChrome.css".text = schizofox.files."userChrome.css".text;
        "${defaultProfile}/chrome/userContent.css".text = schizofox.files."userContent.css".text;
        "${defaultProfile}/user.js".text = schizofox.files."user.js".text;
      };
    };

    systemd.user.services.searx-randomizer = mkIf cfg.search.searxRandomizer.enable schizofox.searx-randomizer-unit;

    assertions = [
      {
        assertion = hasInfix "esr" cfg.package.version;
        message = ''
          The package provided to 'programs.schizofox.package' is not an ESR release
          of Firefox: ${cfg.package.pname}

          For policies to function as intended, you must an ESR release of Firefox.
          If you think this is a mistake, please open an issue and let us know.
        '';
      }
    ];
  };
}
