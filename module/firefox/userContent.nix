{
  cfg,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in ''
  ${mkIf cfg.misc.simplefox.enable ''
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

  ${cfg.theme.extraUserContent}
''
