{
  cfg,
  pkgs,
  lib,
}: {
  preferences = (import ./preferences.nix {inherit cfg lib;}) // cfg.settings;
  chrome = {
    userChrome = import ./userChrome.nix {inherit cfg lib pkgs;};
    userContent = import ./userContent.nix {inherit cfg lib pkgs;};
  };
  policies = import ./policies.nix {inherit cfg pkgs lib;};
  wrapWithProxychains = cfg.security.wrapWithProxychains;
  sandbox = {
    inherit (cfg.security.sandbox) enable extraBinds allowFontPaths;
    inherit (cfg.misc) customMozillaFolder;
  };
  searchService = {
    inherit (cfg.search.searxRandomizer) instances;
  };
}
