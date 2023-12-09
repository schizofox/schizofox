{
  systems = ["x86_64-linux" "aarch64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      # Extensions
      darkreader = pkgs.callPackage ./darkreader.nix {};
    };
  };
}
