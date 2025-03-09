{
  nixosTest,
  inputs,
  homeManagerModules,
  nixosModules,
  ...
}:
nixosTest {
  name = "basic";

  nodes.machine = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      
      inputs.hjem.nixosModules.default
      nixosModules.schizofox

      ../profiles/test-setup.nix
    ];
    home-manager.sharedModules = [
      homeManagerModules.schizofox
    ];

    home-manager.users.test = {
      programs.schizofox = {
        enable = true;
        security.sandbox.enable = true;
      };
    };

    hjem.users.test = {
      programs.schizofox = {
        enable = true;
        security.sandbox.enable = true;
      };
    };
  };

  testScript = "";
}
