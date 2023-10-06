_: {
  systems = ["x86_64-linux" "aarch64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      # Extensions
      darkreader = pkgs.callPackage ./darkreader.nix {};

      # Simplefox
      userChrome = pkgs.callPackage ./simplefox/userChrome.nix {};
      userContent = pkgs.callPackage ./simplefox/userContent.nix {};
    };
  };
}
