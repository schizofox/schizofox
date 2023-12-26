{
  cfg,
  lib,
  pkgs,
  self,
}: let
  inherit (cfg.theme.colors) background-darker background border;
  userChrome = self.packages.${pkgs.stdenv.hostPlatform.system}.userChrome.override {
    backgroundDarker = background-darker;
    inherit background border;
    inherit (cfg.theme) font;
  };
in ''
  ${lib.optionalString cfg.extensions.simplefox.enable (builtins.readFile userChrome)}
  ${cfg.theme.extraUserChrome}
''
