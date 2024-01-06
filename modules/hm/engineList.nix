cfg: [
  {
    Name = "Sourcegraph/Nix";
    Description = "Sourcegraph nix search";
    Alias = "!snix";
    Method = "GET";
    URLTemplate = "https://sourcegraph.com/search?q=context:global+file:.nix%24+{searchTerms}&patternType=literal";
  }
  {
    Name = "Stackoverflow";
    Description = "Stealing code";
    Alias = "!so";
    Method = "GET";
    URLTemplate = "https://stackoverflow.com/search?q={searchTerms}";
  }
  {
    Name = "Wikipedia";
    Description = "Wikiless";
    Alias = "!wiki";
    Method = "GET";
    URLTemplate = "https://wikiless.org/w/index.php?search={searchTerms}title=Special%3ASearch&profile=default&fulltext=1";
  }
  {
    Name = "Crates.io";
    Description = "Rust crates";
    Alias = "!rs";
    Method = "GET";
    URLTemplate = "https://crates.io/search?q={searchTerms}";
  }
  {
    Name = "nixpkgs";
    Description = "Nixpkgs query";
    Alias = "!nix";
    Method = "GET";
    URLTemplate = "https://search.nixos.org/packages?&query={searchTerms}";
  }
  {
    Name = "Phind";
    Description = "Phind AI search";
    Alias = "!pd";
    Method = "GET";
    URLTemplate = "https://www.phind.com/search?q={searchTerms}&source=searchbox";
  }
  {
    Name = "Searx";
    Description = "Searx";
    Alias = "!sx";
    Method = "GET";
    URLTemplate =
      if cfg.search.searxRandomizer.enable
      then "http://127.0.0.1:8000/search?q={searchTerms}"
      else cfg.search.searxQuery;
  }
]
