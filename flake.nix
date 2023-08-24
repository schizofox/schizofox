{
  description = "Firefox configuration flake for delusional and schizophrenics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs = {
    flake-parts,
    self,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [./pkgs];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        # add more systems if they are supported
      ];

      perSystem = {pkgs, ...}: {
        devShells.default = pkgs.mkShell {
          name = "schizofox-dev";
          packages = with pkgs; [
            statix
            deadnix
          ];
        };
        formatter = pkgs.alejandra;
      };

      flake = {
        homeManagerModule = self.homeManagerModules.default self;
        homeManagerModules = rec {
          schizofox = import ./module/hm.nix;
          default = schizofox;
        };
      };
    };
}
