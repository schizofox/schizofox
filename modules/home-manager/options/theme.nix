{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption literalExpression;
  inherit (lib.types) str;
in {
  options.programs.schizofox.theme = {
    colors = {
      background-darker = mkOption {
        type = str;
        example = "181825";
        default = "181825";
        description = "Darker background color";
      };

      background = mkOption {
        type = str;
        example = "1e1e2e";
        default = "1e1e2e";
        description = "Background color";
      };

      foreground = mkOption {
        type = str;
        example = "cdd6f4";
        default = "cdd6f4";
        description = "Text color";
      };

      primary = mkOption {
        type = str;
        example = "aaf2ff";
        default = "aaf2ff";
        description = "Primary accent color";
      };

      border = mkOption {
        type = str;
        example = "00000000";
        default = "00000000";
        description = "Border color";
      };
    };

    font = mkOption {
      type = str;
      example = "Lato";
      default = "Lexend";
      description = "Default firefox font";
    };

    defaultUserChrome.enable = mkEnableOption "default userChrome for Schizofox" // {default = true;};
    defaultUserContent.enable = mkEnableOption "default userContent for Schizofox" // {default = true;};

    extraUserChrome = mkOption {
      type = str;
      default = "";
      example = literalExpression ''
        body {
          background-color: red;
        }
      '';
      description = "Extra css for userChrome.css";
    };

    extraUserContent = mkOption {
      type = str;
      default = "";
      example = literalExpression ''
        body {
          background-color: red;
        }
      '';
      description = "Extra css for userContent.css";
    };
  };
}
