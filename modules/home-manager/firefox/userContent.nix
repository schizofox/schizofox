{
  cfg,
  lib,
  self,
  pkgs,
}: let
  inherit (cfg.theme) font extraUserContent;
  inherit (cfg.theme.colors) background background-darker foreground primary border;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) userContent;
in ''

  ${
    lib.optionalString cfg.theme.defaultUserContent.enable ''
      @-moz-document url-prefix("about:") {
        * {
          font-family: "${font}" !important;
        }

        html {
          background: #${background-darker};
        }

        :root {
          --in-content-page-background: #${background-darker} !important;
          --in-content-page-color: #${foreground} !important;

          --in-content-text-color: #${foreground} !important;

          --in-content-box-background: #${background} !important;
          --in-content-box-info-background: #${background} !important;
          --in-content-box-border-color: #${border} !important;

          --in-content-table-background: #${background} !important;

          --newtab-background-color: #${background-darker} !important;
          --newtab-background-color-secondary: #${background} !important;
          --newtab-text-primary-color: #${foreground} !important;
          --newtab-primary-element-text-color: #${background-darker} !important;
          --newtab-primary-action-background: #${primary} !important;

          --brand-color-accent: #${primary} !important;
          --color-accent-primary-hover: #${primary} !important;
          --color-accent-primary-active: #${primary} !important;

          --in-content-primary-button-background: #${primary} !important;
          --in-content-primary-button-background-active: #${primary} !important;
          --in-content-primary-button-background-hover: #${primary} !important;
          --in-content-primary-button-text-color: #${background-darker} !important;

          --checkbox-unchecked-bgcolor: #${background} !important;
          --checkbox-unchecked-hover-bgcolor: #${background} !important;

          --in-content-button-background: #${background} !important;
          --in-content-button-background-hover: #${background} !important;

          --card-shadow: transparent !important;
        }

        .search-wrapper .logo-and-wordmark .wordmark {
          fill: #${foreground} !important;
        }

        .checkbox-check[checked] {
          color: #${background-darker} !important;
        }

        html|button[autofocus], html|button[type="submit"], xul|button[default], button.primary {
          background-color: #${primary} !important;
        }

        panel {
          --panel-background: #${background} !important;
          --panel-color: #${foreground} !important;
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
