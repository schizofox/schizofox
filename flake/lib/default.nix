{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  extendedLib = lib.extend (self: super: let
    callLibs = file: import file {lib = self;};
  in {
    schizoLib = {
      extensions = callLibs ./extensions;
    };

    inherit (self.schizoLib.extensions) mkForceInstalled;
    schizofoxOptions = ./schizofox/options;
    schizofoxArgsFromModule = import ./schizofox/from-module.nix;
  });
in {
  perSystem._module.args.lib = extendedLib;
  flake.lib = extendedLib;
}
