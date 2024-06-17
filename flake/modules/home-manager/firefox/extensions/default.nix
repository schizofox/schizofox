{
  self,
  pkgs,
  lib,
  cfg,
  ...
}: let
  inherit (lib.attrsets) mapAttrs optionalAttrs filterAttrs;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) darkreader;

  reader = darkreader.override {
    inherit (cfg.theme.colors) background foreground;
  };

  ext = cfg.extensions;

  # TODO: move these functions to a local library output defined by the flake.
  # Ideally we would do something like self.lib.mkForceInstalled.
  removeNullAttrs = filterAttrs (_: value: value != null);
  mkForceInstalled = mapAttrs (_: cfg: {installation_mode = "force_installed";} // cfg);

  # HACK: Convert this to use mkMerge once the whole project uses the module system.
  addons =
    optionalAttrs ext.enableDefaultExtensions ext.defaultExtensions
    // optionalAttrs ext.enableExtraExtensions ext.extraExtensions
    // optionalAttrs ext.darkreader.enable {"addon@darkreader.org".install_url = "file://${reader}/release/darkreader-firefox.xpi";};
in
  mkForceInstalled (removeNullAttrs addons)
