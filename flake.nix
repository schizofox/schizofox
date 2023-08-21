{
  description = "Schizofox flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {
        pkgs,
        config,
        ...
      }: {
        formatter = pkgs.alejandra;
      };
      flake = {
        homeManagerModules = {
          schizofox = import ./module.nix;
          default = self.homeManagerModules.schizofox;
        };

        homeManagerModule = self.homeManagerModules.default;
      };
    };
}
