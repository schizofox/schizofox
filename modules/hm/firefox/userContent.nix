{ cfg }: ''
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

  ${cfg.theme.extraContentCss}
''
