{
  cfg,
  lib,
  pkgs,
}: ''
  ${lib.optionalString cfg.extensions.simplefox.enable builtins.readfile pkgs.userChrome}
  ${cfg.theme.extraUserChrome}
''
