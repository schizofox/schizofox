{self, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib.options) mkOption;
    inherit (lib.types) listOf anything;
    tack = import ../../.tack;

    darkreaderPkg = pkgs.callPackage ../lib/schizofox/darkreader/package.nix {};
    userChromePkg = pkgs.callPackage ../lib/schizofox/simplefox/userChrome.nix {};
    userContentPkg = pkgs.callPackage ../lib/schizofox/simplefox/userContent.nix {};
    defaultCfg = lib.evalModules {
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
    syntheticConfig = {
      programs.schizofox = defaultCfg.config.programs.schizofox;
    };
    schizofox = (pkgs.callPackage self.lib.mkSchizofox {config = syntheticConfig;}) {
      mode = "nixos";
    };
  in {
    packages = {
      darkreader = darkreaderPkg;
      userChrome = userChromePkg;
      userContent = userContentPkg;
      searx-randomizer = tack.searx-randomizer.packages.${pkgs.system}.default;
      schizofox = schizofox.package;
    };
  };
}
