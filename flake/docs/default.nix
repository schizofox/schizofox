{self, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    inherit (lib.options) mkOption;
    inherit (lib.types) listOf anything;

    evaluatedOptions = lib.evalModules {
      modules = [
        self.lib.schizofoxOptions
        {
          options.assertions = mkOption {
            type = listOf anything;
            default = [];
            description = "Assertions evaluated by the module system.";
          };
        }
      ];
      specialArgs = {inherit pkgs;};
    };
    optionsJSON =
      (pkgs.nixosOptionsDoc {
        options = evaluatedOptions.options;
      }).optionsJSON;
  in {
    packages.docs =
      pkgs.runCommandLocal "schizofox-documentation" {
        nativeBuildInputs = [pkgs.ndg];
      } ''
        ndg html \
          --input-dir ${../../docs} \
          --output-dir "$out" \
          --title "Schizofox" \
          --module-options ${optionsJSON}/share/doc/nixos/options.json \
          --options-filter-prefix programs.schizofox \
          --jobs "$NIX_BUILD_CORES"
      '';
  };
}
