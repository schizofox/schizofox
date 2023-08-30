{
  nixosTest,
  inputs,
  homeManagerModules,
  ...
}:
nixosTest {
  name = "basic";

  nodes.machine = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      ./profiles/test-setup.nix
    ];
    home-manager.sharedModules = [
      homeManagerModules.schizofox
    ];

    home-manager.users.test = {
      programs.schizofox.enable = true;
    };
  };

  testScript = "";
}
