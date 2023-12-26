{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkPackageOption mdDoc types literalExpression;

  cfg = config.programs.schizofox;
in {
  options.programs.schizofox.theme = {
    font = mkOption {
      type = types.str;
      example = "Lato";
      default = "Lexend";
      description = "Default firefox font";
    };

    background-darker = mkOption {
      type = types.str;
      example = "181825";
      default = "181825";
      description = "Darker background color";
    };

    background = mkOption {
      type = types.str;
      example = "1e1e2e";
      default = "1e1e2e";
      description = "Dark reader background color";
    };

    foreground = mkOption {
      type = types.str;
      example = "cdd6f4";
      default = "cdd6f4";
      description = "Dark reader text color";
    };

    # simple fox options
    simplefox = {
      enable = mkEnableOption ''
        A Userstyle theme for Firefox minimalist and Keyboard centered.
      '';

      showUrlBar = mkEnableOption ''
        Show the URL bar on hover.
      '';
    };

    # TODO: patchDefaultColors bool option
    darkreader.enable =
      mkEnableOption ''
        Dark mode on all sites (patched to match overall theme)
      ''
      // {default = true;}; # no escape

    extraUserChrome = mkOption {
      type = types.str;
      example = ''
        body {
          background-color: red;
        }
      '';
      default = "";
      description = "Extra css for userChrome.css";
    };

    extraUserContent = mkOption {
      type = types.str;
      example = ''
        body {
          background-color: red;
        }
      '';
      default = "";
      description = "Extra css for userContent.css";
    };
  };
}
