{
  # TODO: move functions and helpers used in the module to this file

  mkForceInstalled = builtins.mapAttrs (_: cfg: {installation_mode = "force_installed";} // cfg);
}
