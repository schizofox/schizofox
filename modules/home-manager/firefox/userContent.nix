{
  cfg,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in ''
  ${mkIf cfg.theme.simplefox.enable ''
    /*
    ┌─┐┬┌┬┐┌─┐┬  ┌─┐
    └─┐││││├─┘│  ├┤
    └─┘┴┴ ┴┴  ┴─┘└─┘
    ┌─┐┌─┐─┐ ┬
    ├┤ │ │┌┴┬┘
    └  └─┘┴ └─

    by Miguel Avila

    */

    :root {
      scrollbar-width: none !important;
    }

    @-moz-document url(about:privatebrowsing) {
      :root {
        scrollbar-width: none !important;
      }
    }
  ''}

  ${
    mkIf (cfg.theme.extraUserContent != "") ''
      ${cfg.theme.extraUserContent}
    ''
  }
''
