{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkEnableOption types literalExpression;

  cfg = config.programs.schizofox;
in {
  options.programs.schizofox.search = {
    defaultEngine = mkOption {
      type = types.str;
      default = "DuckDuckGo";
      example = literalExpression ''"Brave"'';
      description = "Default search engine";
    };

    addEngines = mkOption {
      type = with types; listOf attrs;
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
      type = with types; listOf str;
      default = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
      description = "List of search engines to remove from the defaults provided";
      example = literalExpression ''["LibRedirect"]'';
    };

    searxUrl = mkOption {
      type = types.str;
      default = "https://searx.be";
      description = "Searx instance url";
      example = literalExpression "https://search.example.com";
    };

    searxQuery = mkOption {
      type = types.str;
      default = "${cfg.search.searxUrl}/search?q={searchTerms}&categories=general";
      description = "Search query for the Searx(ng) instance";
      example = literalExpression "https://searx.be/search?q={searchTerms}&categories=general";
    };

    searxRandomizer = {
      enable = mkEnableOption ''
        selecting a random Searx(ng) instance while making a browser query. The default
        list contains an instance hosted by one of the Schizofox maintainers. You may
        set `searxRandomizer.instances = lib.mkForce [ ]` if this is undesirable.
      '';

      instances = mkOption {
        type = with types; listOf str;
        default = ["searx.be" "search.notashelf.dev"];
        example = ["searx.be" "search.notashelf.dev"];
        description = "Instances for searx randomizer";
      };
    };
  };
}
