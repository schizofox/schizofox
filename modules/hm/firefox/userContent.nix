{
  lib,
  cfg,
  pkgs,
}: ''
  ${lib.optionalString cfg.extensions.simplefox.enable (builtins.readfile pkgs.userContent)}
  ${cfg.theme.extraUserContent}
''
