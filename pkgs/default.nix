{inputs, ...}: {
  systems = ["x86_64-linux" "aarch64-linux"];

  perSystem = {pkgs, ...}: let
    docs = import ../docs {
      inherit pkgs;
      nmdSrc = inputs.nmd;
    };
  in {
    packages = {
      # Extensions
      darkreader = pkgs.callPackage ./darkreader.nix {};

      # Simplefox
      userChrome = pkgs.callPackage ./simplefox/userChrome.nix {};
      userContent = pkgs.callPackage ./simplefox/userContent.nix {};

      # Documentation
      docs = docs.manual.html;
      docs-html = docs.manual.html;
      docs-manpages = docs.manPages;
      docs-json = docs.options.json;
    };
  };
}
