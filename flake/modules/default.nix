{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules = {
      schizofox = import ./nixos {inherit inputs self;};
      default = self.nixosModules.schizofox;
    };

    homeManagerModules = {
      schizofox = import ./home-manager {inherit inputs self;};
      default = self.homeManagerModules.schizofox;
    };
  };
}
