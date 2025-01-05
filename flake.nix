{
  description = "Hardened Firefox configuration for the delusional and schizophrenics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # Overridable flake systems.
    # See: <https://github.com/nix-systems/nix-systems>
    systems.url = "github:nix-systems/default-linux";

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
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      imports = [
        ./flake/pkgs # packages exposed by the flake
        ./flake/tests # machine tests
        ./flake/lib # extended library
        ./flake/modules # modules exported by the flake
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
    };
}
