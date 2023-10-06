{
  config,
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    callPackage = lib.callPackageWith (pkgs
      // {
        inherit (config.flake) homeManagerModules;
        inherit inputs;
      });
  in {
    checks = {
      basic = callPackage ./checks/basic.nix {};
      nixpak = callPackage ./checks/nixpak.nix {};
    };
    packages.test = self'.checks.basic.driverInteractive;
  };
}
