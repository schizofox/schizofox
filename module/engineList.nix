cfg: {
  defaultEngines = [
    {
      Name = "Sourcegraph/Nix";
      Description = "Sourcegraph nix search";
      Alias = "!snix";
      Method = "GET";
      URLTemplate = "https://sourcegraph.com/search?q=context:global+file:.nix%24+{searchTerms}&patternType=literal";
    }
    {
      Name = "Torrent search";
      Description = "Searching for legal linux isos ";
      # feds go away
      Alias = "!torrent";
      Method = "GET";
      URLTemplate = "https://librex.beparanoid.de/search.php?q={searchTerms}&t=3&p=0";
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
      Name = "Searx";
      Description = "Searx";
      Alias = "!sx";
      Method = "GET";
      URLTemplate = cfg.searxQuery;
    }
  ];
}
