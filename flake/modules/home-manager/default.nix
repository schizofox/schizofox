{
  self,
  inputs,
}: {
  options,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasInfix;

  cfg = config.programs.schizofox;

  maybeTheme = theme:
    if theme == null
    then null
    else theme.package;
  schizofoxPkgs =
    if pkgs ? mkSchizofox
    then pkgs
    else pkgs.extend self.overlays.default;
  schizofox = schizofoxPkgs.mkSchizofox (
    (self.lib.schizofoxArgsFromModule {
      inherit cfg lib;
      pkgs = schizofoxPkgs;
    })
    // {
      firefox-unwrapped = cfg.package;
      prefName = cfg.prefName;
      wrapFirefox = cfg.wrapFirefox;
      wrapperArgs = cfg.wrapperArgs;
      cursorTheme =
        if lib.any (definition: definition ? package) options.home.pointerCursor.definitions
        then config.home.pointerCursor.package
        else null;
      iconTheme = maybeTheme config.gtk.iconTheme;
      gtkTheme = maybeTheme config.gtk.theme;
      nixpakLib = inputs.nixpak.lib.nixpak {
        inherit (schizofoxPkgs) lib;
        pkgs = schizofoxPkgs;
      };
    }
  );
in {
  meta.maintainers = with lib.maintainers; [NotAShelf];
  imports = [self.lib.schizofoxOptions];
  config = mkIf cfg.enable {
    home.packages = [schizofox.package];

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
