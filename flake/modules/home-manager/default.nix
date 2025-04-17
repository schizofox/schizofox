self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasInfix;
  common = import ../common/files.nix {
    inherit
      config
      lib
      pkgs
      self
      profilesPath
      cursorTheme
      iconTheme
      gtkTheme
      ;
  };

  # https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix#L46

  cfg = config.programs.schizofox;

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

  gtkTheme = maybeTheme config.gtk.theme;

  iconTheme = maybeTheme config.gtk.iconTheme;

  cursorTheme = maybeTheme config.home.pointerCursor;

  defaultProfile = "${profilesPath}/schizo.default";
in {
  meta.maintainers = with lib.maintainers; [sioodmy NotAShelf];
  imports = [../common/options];
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
      "${firefoxConfigPath}/profiles.ini".text = common.files."profiles.ini".text;
      # userChrome content
      "${defaultProfile}/chrome/userChrome.css".text = common.files."userChrome.css".text;
      # userContent
      "${defaultProfile}/chrome/userContent.css".text = common.files."userContent.css".text;
      # user.js
      "${defaultProfile}/user.js".text = common.files."user.js".text;
    };

    home.packages = common.packages;

    # Start a local Systemd service for responding to requests with a random
    # Searxng instance to handle the request. Searxng instances will be selected
    # from the list of instances passed to `search.searxRandomizer.instances`
    systemd.user.services.searx-randomizer = mkIf cfg.search.searxRandomizer.enable common.searx-randomizer-unit;
  };
}
