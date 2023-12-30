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
    colors = {
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
        description = "Background color";
      };

      foreground = mkOption {
        type = types.str;
        example = "cdd6f4";
        default = "cdd6f4";
        description = "Text color";
      };

      primary = mkOption {
        type = types.str;
        example = "aaf2ff";
        default = "aaf2ff";
        description = "Primary accent color";
      };

      border = mkOption {
        type = types.str;
        example = "00000000";
        default = "00000000";
        description = "Border color";
      };
    };

    font = mkOption {
      type = types.str;
      example = "Lato";
      default = "Lexend";
      description = "Default firefox font";
    };

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
