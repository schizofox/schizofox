{
  cfg,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (cfg.theme) background-darker background foreground font;
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

    /*

    ┌─┐┌─┐┌┐┌┌─┐┬┌─┐┬ ┬┬─┐┌─┐┌┬┐┬┌─┐┌┐┌
    │  │ ││││├┤ ││ ┬│ │├┬┘├─┤ │ ││ ││││
    └─┘└─┘┘└┘└  ┴└─┘└─┘┴└─┴ ┴ ┴ ┴└─┘┘└┘

    */


    #appMenu-popup #appMenu-header-description {
    filter: blur(4px) !important;
    transition: filter 350ms ease-out !important;
    transition-delay: 250ms !important;
    }
    #appMenu-popup #appMenu-fxa-label2:hover #appMenu-header-description {
    filter: blur(0px) !important;
    }

    :root {
      --sfwindow: #${background-darker};
      --sfsecondary: #${background};
      --mff-tab-font-family: "${font}";
      --mff-tab-font-size: 11pt;
      --mff-tab-font-weight: 400;
      --mff-urlbar-font-family: "${font}";
      --mff-urlbar-font-size: 11pt;
     ������ --mff-urlbar-font-weight: 700;
      --mff-urlbar-results-font-family: "${font}";
      --mff-urlbar-results-font-size: 11pt;
      --mff-urlbar-results-font-weight: 700;
    }

    ������/* Urlbar View */

    /*─────────────────────────────*/
   ������ /* Comment this section if you */
    /* want to show the URL Bar    */
    /*─────────────────────────────*/

    .urlbarView {
      display: none !important;
  ������  }

    /*─────────────────────────────*/

    /*
    ┌─┐┌─┐┬  ┌─┐┬─┐┌─┐
    │  │ ││  │ │├┬┘└─┐
    └─┘└─┘┴─┘└─┘┴└─└─┘
    */

    /* Tabs colors  */
    #tabbrowser-tabs:not([movingtab])
      > #tabbrowser-arrowscrollbox
      > .tabbrowser-tab
      > .tab-stack
      > .tab-background[multiselected='true'],
    #tabbrowser-tabs:not([movingtab])
      > #tabbrowser-arrowscrollbox
      > .tabbrowser-tab
      > .tab-stack
      > .tab-background[selected='true'] {
      background-image: none !important;
      background-color: var(--toolbar-bgcolor) !important;
    }

    /* Inactive tabs color */
    #navigator-toolbox {
      background-color: var(--sfwindow) !important;
    }

    /* Window colors  */
    :root {
      --toolbar-bgcolor: var(--sfsecondary) !important;
      --tabs-border-color: var(--sfsecondary) !important;
      --lwt-sidebar-background-color: var(--sfwindow) !important;
      --lwt-toolbar-field-focus: var(--sfsecondary) !important;
    }

    /* Sidebar color  */
    #sidebar-box,
    .sidebar-placesTree {
      background-color: var(--sfwindow) !important;
    }

    /*

    ┌┬┐┌─┐┬  ┌─┐┌┬┐┌─┐
     ││├┤ │  ├┤  │ ├┤
    ─┴┘└─┘┴─┘└─┘ ┴ └─┘
    ┌─┐┌─┐┌┬┐┌─┐┌─┐┌┐┌┌─┐┌┐┌┌┬┐┌─┐
    │  │ ││││├─┘│ ││││├┤ │││ │ └─┐
    └─┘└─┘┴ ┴┴  └─┘┘└┘└─┘┘└┘ ┴ └─┘

    */

    /* Tabs elements  */
    .tab-close-button {
      display: none;
    }

    .tabbrowser-tab:not([pinned]) .tab-icon-image {
      display: none !important;
    }

    #nav-bar:not([tabs-hidden='true']) {
      box-shadow: none;
    }

    #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs])
      > #tabbrowser-arrowscrollbox
      > .tabbrowser-tab[first-visible-unpinned-tab] {
      margin-inline-start: 0 !important;
    }

    :root {
      --toolbarbutton-border-radius: 0 !important;
      --tab-border-radius: 0 !important;
      --tab-block-margin: 0 !important;
    }

    .tab-background {
      border-right: 0px solid rgba(0, 0, 0, 0) !important;
      margin-left: -4px !important;
    }

    .tabbrowser-tab:is([visuallyselected='true'], [multiselected])
      > .tab-stack
      > .tab-background {
      box-shadow: none !important;
    }

    .tabbrowser-tab[last-visible-tab='true'] {
      padding-inline-end: 0 !important;
    }

    #tabs-newtab-button {
      padding-left: 0 !important;
    }

    /* Url Bar  */
    #urlbar-input-container {
      background-color: var(--sfsecondary) !important;
      border: 1px solid rgba(0, 0, 0, 0) !important;
    }

    #urlbar-container {
      margin-left: 0 !important;
    }

    #urlbar[focused='true'] > #urlbar-background {
      box-shadow: none !important;
    }

    #navigator-toolbox {
      border: none !important;
    }

    /* Bookmarks bar  */
    .bookmark-item .toolbarbutton-icon {
      display: none;
    }
    toolbarbutton.bookmark-item:not(.subviewbutton) {
      min-width: 1.6em;
    }

    /* Toolbar  */
    #tracking-protection-icon-container,
    #urlbar-zoom-button,
    #star-button-box,
    #pageActionButton,
    #pageActionSeparator,
    #tabs-newtab-button,
    #back-button,
    #PanelUI-button,
    #forward-button,
    .tab-secondary-label {
      display: none !important;
    }

    .urlbarView-url {
      color: #${foreground} !important;
    }

    /* Disable elements  */
    #context-navigation,
    #context-savepage,
    #context-pocket,
    #context-sendpagetodevice,
    #context-selectall,
    #context-viewsource,
    #context-inspect-a11y,
    #context-sendlinktodevice,
    #context-openlinkinusercontext-menu,
    #context-bookmarklink,
    #context-savelink,
    #context-savelinktopocket,
    #context-sendlinktodevice,
    #context-searchselect,
    #context-sendimage,
    #context-print-selection {
      display: none !important;
    }

    #context_bookmarkTab,
    #context_moveTabOptions,
    #context_sendTabToDevice,
    #context_reopenInContainer,
    #context_selectAllTabs,
    #context_closeTabOptions {
      display: none !important;
    }

  ''}

  //
  ${cfg.theme.extraCss}

''


