{
  pkgs,
  lib,
  searxRandomizerPkg ? pkgs.callPackage ../searx-randomizer/package.nix {},
}: {
  preferences,
  chrome,
  policies,
  wrapWithProxychains,
  sandbox,
  searchService,
  firefox-unwrapped,
  nixpakLib ? null,
  profilePrefName ? "pref",
  cursorTheme ? null,
  iconTheme ? null,
  gtkTheme ? null,
}: let
  wrapperGenerated = import ../../lib/schizofox/files.nix {
    prefName = "pref";
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
      searxRandomizerPkg
      ;
  };
  profileGenerated =
    if profilePrefName == "pref"
    then wrapperGenerated
    else
      import ../../lib/schizofox/files.nix {
        prefName = profilePrefName;
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
          searxRandomizerPkg
          ;
      };
  wrapped = pkgs.callPackage ./firefox.nix {
    inherit firefox-unwrapped policies wrapWithProxychains;
    inherit (wrapperGenerated) files;
  };
in {
  inherit (profileGenerated) files;
  inherit (wrapperGenerated) package searx-randomizer-unit;
  inherit wrapped;
}
