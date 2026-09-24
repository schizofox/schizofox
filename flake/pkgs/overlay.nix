final: _: {
  mkSchizofox = final.callPackage ./schizofox {};
  schizofox-darkreader = final.callPackage ./darkreader/package.nix {};
  schizofox-searx-randomizer = final.callPackage ./searx-randomizer/package.nix {};
  schizofox-userChrome = final.callPackage ./simplefox/userChrome.nix {};
  schizofox-userContent = final.callPackage ./simplefox/userContent.nix {};
}
