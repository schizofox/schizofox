{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  tack = import ../../.tack;
  extendedLib = lib.extend (self: super: let
    callLibs = file: import file {lib = self;};
  in {
    schizoLib = {
      extensions = callLibs ./extensions;
    };

    inherit (self.schizoLib.extensions) mkForceInstalled;
    mkSchizofox = import ./schizofox {inherit inputs tack;};
    schizofoxOptions = ./schizofox/options;
  });
in {
  perSystem.imports = [{_module.args.lib = extendedLib;}];
  flake.lib = extendedLib;
}
