{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in
{
  options.programs.schizofox = {
    userName = mkOption {
      type = str;
      default = "";
      description = "Name of the user to install the configuration for";
      example = "ryan";
    };
  };
}
