{
  description = "Firefox configuration flake for delusional and schizophrenics";

  outputs = {
    flake-parts,
    self,
    nixpkgs,
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
        formatter = pkgs.alejandra;

        # provide nix diagnostics - do not run with --fix options unless you know what you are doing
        devShells.default = pkgs.mkShell {
          name = "schizofox-dev";
          packages = with pkgs; [
            statix
            deadnix
          ];
        };
      };

      flake = {
        lib = {
          inherit (import ./lib/extended-lib.nix nixpkgs.lib) schizofox;
        };

        homeManagerModule = self.homeManagerModules.schizofox; # an alias to the default module
        homeManagerModules = {
          schizofox = import ./modules/hm self;
          default = self.homeManagerModules.schizofox;
        };
      };
    };

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

    searx-randomizer = {
      url = "github:schizofox/searx-randomizer";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nmd = {
      url = "sourcehut:~rycee/nmd";
      flake = false;
    };

    wavefox = {
      url = "github:QNetITQ/WaveFox/v1.6.115";
      flake = false;
    };
  };
}
