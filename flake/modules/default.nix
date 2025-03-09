{self, ...}: {
  flake = {
    homeManagerModule = self.homeManagerModules.schizofox; # an alias to the default module
    homeManagerModules = {
      schizofox = import ./schizofox/home-manager.nix self;
      default = self.homeManagerModules.schizofox;
    };

    nixosModule = self.nixosModules.schizofox;
    nixosModules = {
      schizofox = let inherit self; in {
        hjem.extraModules = [(import ./schizofox/nixos.nix self)];
      };
      default = self.nixosModules.schizofox;
    };
  };
}
