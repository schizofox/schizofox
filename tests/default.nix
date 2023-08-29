{ config, inputs, lib, ... }:

{
  perSystem = { pkgs, self', ... }: let
    callPackage = lib.callPackageWith (pkgs // {
      inherit (config.flake) homeManagerModules;
      inherit inputs;
    });
  in {
    checks = {
      basic = callPackage ./basic.nix { };
    };
    packages.test = self'.checks.basic.driverInteractive;
  };
}
