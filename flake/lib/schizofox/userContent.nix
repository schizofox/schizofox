{
  cfg,
  lib,
  pkgs,
}: let
  inherit (cfg.theme) font extraUserContent;
  inherit (cfg.theme.colors) background background-darker foreground primary border;
  userContent = pkgs.schizofox-userContent;
in ''

  ${
    lib.optionalString cfg.theme.defaultUserContent.enable ''
      @-moz-document url-prefix("about:") {
        * {
          font-family: "${font}" !important;
        }

        :root {
          --background-color-canvas: #${background-darker} !important;
          --text-color: #${foreground} !important;

          --background-color-box: #${background} !important;
          --background-color-box-info: #${background} !important;
          --border-color: #${border} !important;

          --table-background-color: #${background} !important;

          --newtab-background-color: #${background-darker} !important;
          --newtab-background-color-secondary: #${background} !important;
          --newtab-text-primary-color: #${foreground} !important;
          --newtab-primary-element-text-color: #${background-darker} !important;
          --newtab-primary-action-background: #${primary} !important;

          --color-accent-primary: #${primary} !important;
          --color-accent-primary-hover: #${primary} !important;
          --color-accent-primary-active: #${primary} !important;

          --button-background-color-primary: #${primary} !important;
          --button-background-color-primary-active: #${primary} !important;
          --button-background-color-primary-hover: #${primary} !important;
          --button-text-color-primary: #${background-darker} !important;

          --checkbox-background-color: #${background} !important;
          --checkbox-background-color-hover: #${background} !important;

          --button-background-color: #${background} !important;
          --button-background-color-hover: #${background} !important;
          --button-background-color-active: #${background} !important;
          --button-text-color: #${foreground} !important;

          --card-shadow: transparent !important;
        }

        .search-wrapper .logo-and-wordmark .wordmark {
          fill: #${foreground} !important;
        }

        .checkbox-check[checked] {
          color: #${background-darker} !important;
        }

        button[autofocus], button[type="submit"], button[default], button.primary {
          background-color: #${primary} !important;
        }

        panel {
          --panel-background-color: #${background} !important;
          --panel-text-color: #${foreground} !important;
        }

        panel-list {
          background: #${background} !important;
        }

        input[type="checkbox"]:enabled:checked,
        input[type="checkbox"]:enabled:checked:hover {
          background-color: #${primary} !important;
        }

        #trackingProtectionShield {
          color: #${primary} !important;
        }

        .dialogBox {
          background-color: #${background-darker} !important;
        }

        dialog {
          background-color: #${background-darker} !important;
          color: #${foreground} !important;
        }

        .privacy-detailedoption {
          background-color: #${background} !important;
        }

        .addon-detail-actions input[type="radio"]:not(:checked) {
          background-color: #${background-darker} !important;
        }

        .theme-enable-button {
          background-color: #${background-darker} !important;
        }

        .toggle-button {
          --toggle-background-color: #${background-darker} !important;
          --toggle-background-color-hover: #${background-darker} !important;
          --toggle-background-color-active: #${background-darker} !important;
          --toggle-border-color: #${foreground} !important;
        }
      }
    ''
  }

  ${lib.optionalString cfg.extensions.simplefox.enable (builtins.readFile userContent)}

  ${extraUserContent}
''
