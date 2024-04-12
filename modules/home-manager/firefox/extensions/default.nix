{
  lib,
  pkgs,
  self,
  cfg,
  ...
}: let
  ext = cfg.extensions;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) darkreader;
  reader = darkreader.override {
    inherit (cfg.theme.colors) background foreground;
  };

  # TODO: move to this to its own custom lib
  # i.e inputs.schizofox.schizolib.mkForceInstalled
  mkForceInstalled = builtins.mapAttrs (_: cfg: {installation_mode = "force_installed";} // cfg);
  addons =
    ext.defaultExtensions
    // lib.optionalAttrs ext.darkreader.enable {"addon@darkreader.org".install_url = "file://${reader}/release/darkreader-firefox.xpi";}
    // lib.optionalAttrs (ext.extraExtensions != {}) ext.extraExtensions;
in
  mkForceInstalled addons
