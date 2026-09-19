{self}: {
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasInfix;

  cfg = config.programs.schizofox;

  schizofox = (pkgs.callPackage self.lib.mkSchizofox {inherit config;}) {
    mode = "nixos";
  };
in {
  meta.maintainers = with lib.maintainers; [sioodmy NotAShelf];
  imports = [self.lib.schizofoxOptions];
  config = mkIf cfg.enable {
    environment.systemPackages = [schizofox.package];
    systemd.user.units.searx-randomizer = mkIf cfg.search.searxRandomizer.enable schizofox.searx-randomizer-unit;

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
