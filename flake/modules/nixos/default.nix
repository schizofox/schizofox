self:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenvNoCC.hostPlatform) isDarwin;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasInfix;
  common = import ../common/files.nix {
    inherit
      config
      lib
      pkgs
      self
      usingNixosModule
      cursorTheme
      iconTheme
      gtkTheme
      ;
  };

  cfg = config.programs.schizofox;

  usingNixosModule = true;

  mozillaConfigPath =
    if isDarwin then "Library/Application Support/Mozilla" else "/home/NOT_USED/.mozilla";

  firefoxConfigPath =
    if isDarwin then "Library/Application Support/Firefox" else mozillaConfigPath + "/firefox";

  profilesPath = if isDarwin then "${firefoxConfigPath}/Profiles" else firefoxConfigPath;

  maybeTheme =
    opt:
    lib.findFirst builtins.isNull opt.package [
      opt
      opt.package
    ];

  gtkTheme = null; # maybeTheme config.gtk.theme;

  iconTheme = null; # maybeTheme config.gtk.iconTheme;

  cursorTheme = null; # maybeTheme config.home.pointerCursor;

  defaultProfile = "${profilesPath}/schizo.default";
in
{
  meta.maintainers = with lib.maintainers; [
    sioodmy
    NotAShelf
  ];
  imports = [
    ../common/options
  ];
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

    environment.systemPackages = common.packages;

    # Start a local Systemd service for responding to requests with a random
    # Searxng instance to handle the request. Searxng instances will be selected
    # from the list of instances passed to `search.searxRandomizer.instances`
    systemd.user.units.searx-randomizer = mkIf cfg.search.searxRandomizer.enable common.searx-randomizer-unit;
  };
}
