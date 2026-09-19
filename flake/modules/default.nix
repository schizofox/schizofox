{self, ...}: {
  flake = {
    nixosModules = {
      schizofox = import ./nixos {inherit self;};
      default = self.nixosModules.schizofox;
    };

    homeManagerModules = {
      schizofox = import ./home-manager {inherit self;};
      default = self.homeManagerModules.schizofox;
    };
  };
}
