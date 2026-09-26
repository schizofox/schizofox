{
  pkgs,
  lib,
}: {
  preferences,
  chrome,
  policies,
  wrapWithProxychains,
  sandbox,
  searchService,
  firefox-unwrapped,
  nixpakLib ? null,
  prefName ? "pref",
  cursorTheme ? null,
  iconTheme ? null,
  gtkTheme ? null,
  wrapFirefox ? pkgs.wrapFirefox,
  wrapperArgs ? {},
}: let
  generated = import ./generated.nix {
    wrappedPackage = wrapped;
    inherit
      preferences
      chrome
      sandbox
      searchService
      gtkTheme
      iconTheme
      cursorTheme
      lib
      nixpakLib
      pkgs
      prefName
      ;
  };

  wrapped = pkgs.callPackage ./firefox.nix {
    inherit firefox-unwrapped policies wrapWithProxychains wrapFirefox wrapperArgs;
    inherit (generated) autoconfig;
  };
in {
  inherit (generated) package searx-randomizer-unit;
  inherit wrapped;
}
