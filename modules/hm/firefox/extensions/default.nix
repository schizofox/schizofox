{
  lib,
  self,
  pkgs,
  cfg,
  ...
}: let
  ext = cfg.extensions;
  inherit (self.packages.${pkgs.system}) darkreader;
  reader = darkreader.override {
    inherit (cfg.theme) background;
    inherit (cfg.theme) foreground;
  };

  # TODO: move to this to its own custom lib
  # i.e inputs.schizofox.schizolib.mkForceInstalled
  mkForceInstalled = builtins.mapAttrs (_: cfg: {installation_mode = "force_installed";} // cfg);
  addons =
    ext.defaultExtensions
    // lib.optionalAttrs cfg.theme.darkreader.enable {"addon@darkreader.org".install_url = "file://${reader}/release/darkreader-firefox.xpi";}
    // lib.optionalAttrs (ext.extraExtensions != {}) ext.extraExtensions;
in
  mkForceInstalled addons
