{
  inputs,
  mkSchizofox,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
  extendedLib = lib.extend (self: super: let
    callLibs = file: import file {lib = self;};
  in {
    schizoLib = {
      extensions = callLibs ./extensions;
    };

    inherit (self.schizoLib.extensions) mkForceInstalled;
    inherit mkSchizofox;
    schizofoxOptions = ./schizofox/options;
  });
in {
  perSystem._module.args.lib = extendedLib;
  flake.lib = extendedLib;
}
