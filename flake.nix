{
  description = "Hardened Firefox configuration for the delusional and schizophrenics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    flake-compat = {
      url = "git+https://git.lix.systems/lix-project/flake-compat.git";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "i686-linux" "aarch64-linux"];

      imports = [
        ./flake/pkgs # packages exposed by the flake
        ./flake/tests # machine tests
        ./flake/lib # extended library
        ./flake/docs # generated module option documentation
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
