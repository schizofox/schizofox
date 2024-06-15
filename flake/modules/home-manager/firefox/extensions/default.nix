{
  self,
  pkgs,
  lib,
  cfg,
  ...
}: let
  inherit (lib.attrsets) mapAttrs optionalAttrs;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) darkreader;

  reader = darkreader.override {
    inherit (cfg.theme.colors) background foreground;
  };

  ext = cfg.extensions;

  # TODO: move the mkForceInstalled function to a local library output defined by the flake.
  # Ideally we would do something like self.lib.mkForceInstalled.
  mkForceInstalled = mapAttrs (_: cfg: {installation_mode = "force_installed";} // cfg);

  # HACK: We shouldn't really abuse optionalAttrs like this here, but use mkMerge.
  # For some reason though, mkMerge fools mkForceInstalled and causes it to think
  # we are passing a string (what?), so we use optionalAttrs instead.
  addons =
    optionalAttrs ext.enableDefaultExtensions ext.defaultExtensions
    // optionalAttrs ext.enableExtraExtensions ext.extraExtensions
    // optionalAttrs ext.darkreader.enable {"addon@darkreader.org".install_url = "file://${reader}/release/darkreader-firefox.xpi";};
in
  mkForceInstalled addons
