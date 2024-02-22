{
  cfg,
  lib,
  self,
  pkgs,
}: let
  inherit (cfg.theme) font extraUserContent;
  inherit (cfg.theme.colors) background background-darker foreground primary;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) userContent;
in ''
  @-moz-document url-prefix("about:") {
    * {
      font-family: "${font}" !important;
    }

    html {
      background: #${background-darker};
    }

    .search-wrapper .logo-and-wordmark .wordmark {
      fill: #${foreground} !important;
    }

    :root {
      --in-content-page-background: #${background-darker} !important;
      --in-content-page-color: #${foreground} !important;

      --in-content-box-background: #${background} !important;
      --in-content-table-background: #${background} !important;

      --newtab-background-color: #${background-darker} !important;
      --newtab-background-color-secondary: #${background} !important;
      --newtab-text-primary-color: #${foreground} !important;
      --newtab-primary-element-text-color: #${background-darker} !important;
      --newtab-primary-action-background: #${primary} !important;
      --brand-color-accent: #${primary} !important;
      --in-content-primary-button-text-color: #${primary} !important;

      --in-content-primary-button-background: #${primary} !important;
      --in-content-primary-button-background-active: #${primary} !important;
    }
  }

  ${lib.optionalString cfg.extensions.simplefox.enable (builtins.readFile userContent)}

  ${extraUserContent}
''
