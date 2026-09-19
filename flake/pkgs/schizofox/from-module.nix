{
  cfg,
  pkgs,
  lib,
  darkreaderPkg ? pkgs.callPackage ../darkreader/package.nix {},
  userChromePkg ? pkgs.callPackage ../simplefox/userChrome.nix {},
  userContentPkg ? pkgs.callPackage ../simplefox/userContent.nix {},
}: {
  preferences = (import ../../lib/schizofox/preferences.nix {inherit cfg lib;}) // cfg.settings;
  chrome = {
    userChrome = import ../../lib/schizofox/userChrome.nix {inherit cfg lib pkgs userChromePkg;};
    userContent = import ../../lib/schizofox/userContent.nix {inherit cfg lib pkgs userContentPkg;};
  };
  policies = import ../../lib/schizofox/policies.nix {inherit cfg pkgs lib darkreaderPkg;};
  wrapWithProxychains = cfg.security.wrapWithProxychains;
  sandbox = {
    inherit (cfg.security.sandbox) enable extraBinds allowFontPaths;
    inherit (cfg.misc) customMozillaFolder;
  };
  searchService = {
    inherit (cfg.search.searxRandomizer) instances;
  };
}
