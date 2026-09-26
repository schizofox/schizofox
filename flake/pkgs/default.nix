{
  self,
  inputs,
  ...
}: {
  flake.overlays.default = import ./overlay.nix;

  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    inherit (lib.options) mkOption;
    inherit (lib.types) anything listOf;
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
  in {
    # TODO: there is a better pattern for this but I forgot what it was, and I'm too lazy to figure it out
    # right now. It involves legacyPackages I think.
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [self.overlays.default];
    };

    packages = {
      # Extensions and services
      darkreader = pkgs.schizofox-darkreader;
      searx-randomizer = pkgs.schizofox-searx-randomizer;

      # userChrome and userContent
      userChrome = pkgs.schizofox-userChrome;
      userContent = pkgs.schizofox-userContent;

      # Schizofox packages
      schizofox-unwrapped = defaultSchizofoxCfg.config.programs.schizofox.package;
      schizofox-wrapped =
        (pkgs.mkSchizofox (
          (self.lib.schizofoxArgsFromModule {
            cfg = defaultSchizofoxCfg.config.programs.schizofox;
            inherit pkgs lib;
          })
          // {firefox-unwrapped = defaultSchizofoxCfg.config.programs.schizofox.package;}
        ))
        .wrapped;
    };
  };
}
