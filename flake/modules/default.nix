{self, ...}: {
  flake = {
    homeManagerModule = self.homeManagerModules.schizofox; # an alias to the default module
    homeManagerModules = {
      schizofox = import ./schizofox/home-manager.nix self;
      default = self.homeManagerModules.schizofox;
    };

    hjemModule = self.hjemModules.schizofox;
    hjemModules = {
      schizofox = import ./schizofox/hjem.nix self;
      default = self.nixosModules.schizofox;
    };
  };
}
