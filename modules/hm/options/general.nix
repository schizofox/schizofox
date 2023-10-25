{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mdDoc;
in {
  options.programs.schizofox = {
    enable = mkEnableOption (mdDoc "Schizophrenic Firefox ESR setup for the delusional");

    package = mkPackageOption pkgs "firefox-esr-115-unwrapped" {
      example = "firefox-esr-unwrapped";
    };
  };
}
