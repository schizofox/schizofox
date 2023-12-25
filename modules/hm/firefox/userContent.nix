{cfg}: ''
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


  * {
    font-family: "${cfg.theme.font}" !important;
  }

  ${cfg.theme.extraUserContent}
''
