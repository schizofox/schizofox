{
  description = "Firefox configuration flake for delusional and schizophrenics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    flake-parts,
    self,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./pkgs
        ./tests
      ];

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
        homeManagerModule = self.homeManagerModules.schizofox; # an alias to the default module (which is technically deprecated)
        homeManagerModules = {
          schizofox = import ./modules/hm self;
          default = self.homeManagerModules.schizofox;
        };
      };
    };
}
