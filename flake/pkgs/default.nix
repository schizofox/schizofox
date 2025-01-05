{
  perSystem = {pkgs, ...}: {
    packages = {
      # Extensions
      darkreader = pkgs.callPackage ./darkreader/package.nix {};

      # Simplefox
      userChrome = pkgs.callPackage ./simplefox/userChrome.nix {};
      userContent = pkgs.callPackage ./simplefox/userContent.nix {};
    };
  };
}
