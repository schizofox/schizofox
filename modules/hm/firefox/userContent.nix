{cfg}: let
  inherit (cfg.theme) font background background-darker foreground extraUserContent;
in ''
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


  @-moz-document url-prefix("about:") {
    * {
      font-family: "${font}" !important;
    }
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
  }

  html {
    background: #${background-darker};
  }

  .search-wrapper .logo-and-wordmark .wordmark {
    fill: #${foreground} !important;
  }

  ${extraUserContent}
''
