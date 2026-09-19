{self, ...}: {
  _module.args.mkSchizofox = import ./schizofox;

  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib.options) mkOption;
    inherit (lib.types) anything listOf;

    darkreaderPkg = pkgs.callPackage ./darkreader/package.nix {};
    searxRandomizerPkg = pkgs.callPackage ./searx-randomizer/package.nix {};
    userChromePkg = pkgs.callPackage ./simplefox/userChrome.nix {};
    userContentPkg = pkgs.callPackage ./simplefox/userContent.nix {};
    defaultSchizofoxCfg = lib.evalModules {
      specialArgs = {inherit pkgs;};
      modules = [
        self.lib.schizofoxOptions
        {
          options.assertions = mkOption {
            type = listOf anything;
            default = [];
          };
        }
      ];
    };
    mkSchizofox = pkgs.callPackage self.lib.mkSchizofox {
      inherit searxRandomizerPkg;
    };
  in {
    packages = rec {
      darkreader = darkreaderPkg;
      searx-randomizer = searxRandomizerPkg;
      userChrome = userChromePkg;
      userContent = userContentPkg;
      schizofox-unwrapped = defaultSchizofoxCfg.config.programs.schizofox.package;
      schizofox-wrapped =
        (mkSchizofox (
          (import ./schizofox/from-module.nix {
            cfg = defaultSchizofoxCfg.config.programs.schizofox;
            inherit pkgs lib darkreaderPkg userChromePkg userContentPkg;
          })
          // {firefox-unwrapped = schizofox-unwrapped;}
        ))
        .wrapped;
    };
  };
}
