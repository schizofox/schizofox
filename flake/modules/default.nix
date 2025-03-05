{self, ...}: {
  flake = {
    nixosModule = self.nixosModules.schizofox; # an alias to the default module
    nixosModules = {
      schizofox = import ./nixos self;
      default = self.nixosModules.schizofox;
    };
    homeManagerModule = self.homeManagerModules.schizofox; # an alias to the default module
    homeManagerModules = {
      schizofox = import ./home-manager self;
      default = self.homeManagerModules.schizofox;
    };
  };
}
