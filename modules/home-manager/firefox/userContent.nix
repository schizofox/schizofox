{
  cfg,
  lib,
  ...
}: let
  inherit (lib) optionalString;
in ''
  ${optionalString cfg.theme.simplefox.enable ''
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

  ${optionalString (cfg.theme.extraUserContent != "") (builtins.toString cfg.theme.extraUserContent)}
''
