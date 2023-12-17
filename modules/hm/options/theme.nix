{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkPackageOption mdDoc types literalExpression;
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

    darkTheme = mkOption {
      type = types.bool;
      example = true;
      default = true;
      description = "Enable dark theme";
    };

    # wavefox options
    wavefox = {
      enable = mkEnableOption ''
        Firefox CSS Theme/Style for manual customization
      '';

      windowAccentColor = mkOption {
        type = types.bool;
        example = true;
        default = true;
        description = "Use Windows Accent Color";
      };

      transparency = {
        enable = mkEnableOption "transparency";

      
      strength = mkOption {
        type = types.enum ["Default" "Low" "Medium" "High" "VeryHigh"];
        example = "High";
        default = "Default";
        description = "Set firefox transparency";
      };
      };

      tabs = {
        style = mkOption {
          type = types.enum [1 2 3 4 5 6 7 8 9 10 11 12];
          example = 1;
          default = 1;
          description = "See https://github.com/QNetITQ/WaveFox";
        };

        borders = mkEnableOption "Enable borders around tabs";

        separatorSaturation = mkOption {
          type = types.enum ["Low" "Medium"];
          example = "Medium";
          default = "Low";
          description = "Tab separator saturation";
        };

        selectedIndicator = mkOption {
          type = types.bool;
          example = true;
          default = false;
          description = "Enable selected tab indicator";
        };

        pinnedWidth = mkOption {
          type = types.enum ["Low" "High"];
          example = "High";
          default = "Low";
          description = "Width of pinned tabs";
        };

        bottom = mkOption {
          type = types.bool;
          example = true;
          default = false;
          description = "Use bottom tabs layout";
        };

        oneline =  {
          enable = mkEnableOption "oneline";
          style = mkOption {
            type = types.enum [ "TabBarFirst" "NavBarFirst"];
            example = "TabBarFirst";
            default = "NavBarFirst";
            description = "Oneline layout options";
          };
        };

        shadowSaturation = mkOption {
          type = types.enum ["Low" "Medium" "High" "VeryHigh"];
          example = "High";
          default = "Low";
          description = "Saturation of tab shadow";
        };
      };

      menu = {
        density = mkOption {
          type = types.enum ["Compact" "Normal" "Touch"];
          example = "Compact";
          default = "Normal";
          description = "Density of menu items";
        };
        icons = mkOption {
          type = types.enum ["Regular" "Filled"];
          example = "Regular";
          default = "Regular";
          description = "Style of menu icons";
        };
      };

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

    extraCss = mkOption {
      type = types.str;
      example = ''
         body {
           background-color: red;
        }
      '';
      default = "";
      description = "Extra css for userChrome.css";
    };
  };
}
