{
  config,
  lib,
  ...
}: {
  perSystem = {pkgs, ...}: {
    checks = let
      callPackage = lib.callPackageWith (pkgs // {inherit (config.flake) nixosModules;});
    in {
      basic = callPackage ./checks/basic.nix {};
      nixpak = callPackage ./checks/nixpak.nix {};
    };
  };
}
