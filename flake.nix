{
  description = "Schizofox flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    npm-build.url = "github:serokell/nix-npm-buildpackage";
    darkreader = {
      url = "github:darkreader/darkreader";
      flake = false;
    };
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {
        system,
        pkgs,
        config,
        ...
      }: 
      
      # pkgs = import nixpkgs {
      #   inherit system;
      #   overlays = [
      #     inputs.npm-build.overlays.default
      #   ];
      # };
      
      {
        packages = {
          darkreader = pkgs.callPackage ./addons/darkreader.nix {};
       };
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
