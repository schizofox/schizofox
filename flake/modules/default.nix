{self, ...}: {
  flake = {
    homeManagerModule = self.homeManagerModules.schizofox; # an alias to the default module
    homeManagerModules = {
      schizofox = import ./home-manager self;
      default = self.homeManagerModules.schizofox;
    };
  };
}
