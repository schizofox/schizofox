{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption literalExpression;
  inherit (lib.types) str listOf attrs;

  cfg = config.programs.schizofox;
in {
  options.programs.schizofox.search = {
    defaultSearchEngine = mkOption {
      type = str;
      default = "Brave";
      example = literalExpression ''"DuckDuckGo"'';
      description = "Default search engine";
    };

    addEngines = mkOption {
      type = listOf attrs;
      default = import ../engineList.nix cfg;
      description = "List of search engines to add to your Schizofox configuration";
      example = literalExpression ''
        [
          {
            Name = "Etherscan";
            Description = "Checking balances";
            Alias = "!eth";
            Method = "GET";
            URLTemplate = "https://etherscan.io/search?f=0&q={searchTerms}";
          }
        ]
      '';
    };

    removeEngines = mkOption {
      type = listOf str;
      default = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
      description = "List of default search engines to remove";
      example = literalExpression ''["LibRedirect"]'';
    };

    searxUrl = mkOption {
      type = str;
      default = "https://searx.be";
      description = "Searx instance url";
      example = literalExpression "https://search.example.com";
    };

    searxQuery = mkOption {
      type = str;
      default = "${cfg.search.searxUrl}/search?q={searchTerms}&categories=general";
      description = "Search query for searx (or any other schizo search engine)";
      example = literalExpression "https://searx.be/search?q={searchTerms}&categories=general";
    };

    searxRandomizer = {
      enable = mkEnableOption "Randomize searx instances";
      instances = mkOption {
        type = listOf str;
        default = ["searx.be" "search.notashelf.dev"];
        example = literalExpression ''["searx.be" "search.notashelf.dev"]'';
        description = "Instances for searx randomizer";
      };
    };
  };
}
