{
  cfg,
  lib,
  pkgs,
}: let
  inherit (cfg.theme.colors) background-darker background foreground primary border;
  inherit (cfg.theme) font;

  userChrome = pkgs.schizofox-userChrome.override {
    backgroundDarker = background-darker;
    inherit background border font;
  };
in ''
  ${lib.optionalString cfg.extensions.simplefox.enable (builtins.readFile userChrome)}


   ${
    lib.optionalString cfg.theme.defaultUserChrome.enable ''
      * {
        font-family: "${font}" !important;
      }

      :root {
        --toolbar-background-color: #${background} !important;
        --toolbar-text-color: #${foreground} !important;
        --toolbarbutton-icon-fill: #${foreground} !important;

        --toolbox-background-color: #${background-darker} !important;
        --toolbox-background-color-inactive: #${background-darker} !important;
        --toolbox-text-color: #${foreground} !important;
        --toolbox-text-color-inactive: #${foreground} !important;

        --color-accent-primary: #${primary} !important;
        --color-accent-primary-hover: #${primary} !important;
        --color-accent-primary-active: #${primary} !important;

        --panel-background-color: #${background} !important;
        --panel-text-color: #${foreground} !important;
        --panel-background-color-dimmed: #${background} !important;
        --panel-border-color: #${border} !important;

        --toolbar-field-background-color: #${background-darker} !important;
        --toolbar-field-background-color-focus: #${background-darker} !important;
        --toolbar-field-text-color: #${foreground} !important;
        --toolbar-field-text-color-focus: #${foreground} !important;
        --toolbar-field-border-color: #${border} !important;

        --urlbar-box-background-color: #${background} !important;
        --urlbar-box-text-color: #${foreground} !important;

        --checkbox-background-color-checked: #${primary} !important;
        --checkbox-background-color-checked-hover: #${primary} !important;

        --button-background-color-primary: #${primary} !important;
        --button-background-color-primary-hover: #${primary} !important;
        --button-background-color-primary-active: #${primary} !important;
        --button-text-color-primary: #${background-darker} !important;

        --background-color-canvas: #${background-darker} !important;
        --text-color: #${foreground} !important;
        --button-background-color: #${background} !important;
        --button-background-color-hover: #${background} !important;
        --button-background-color-active: #${background} !important;
        --button-text-color: #${foreground} !important;

        --focus-outline-color: #${primary} !important;
        --tab-loading-fill: #${primary} !important;
      }

      #navigator-toolbox {
        background: #${background-darker} !important;
        border-bottom: 1px solid #${border} !important;
      }

      tab {
        color: #${foreground} !important;
      }

      .toolbarbutton-1 {
        color: #${foreground} !important;
      }

      #urlbar {
        color: #${foreground} !important;
      }

      .urlbar-background {
        background: #${background-darker} !important;
        border-color: #${border} !important;
      }

      #menubar-items {
        color: #${foreground} !important;
      }

      menubar > menu[open] {
        border-bottom-color: #${primary} !important;
      }

      .urlbarView-row[selected] {
        background-color: #${primary} !important;
      }

      .urlbarView-row[source="bookmarks"] > .urlbarView-row-inner > .urlbarView-no-wrap > .urlbarView-favicon, #urlbar-engine-one-off-item-bookmarks {
        fill: #${primary} !important;
      }

      .urlbarView-row-inner:not(:selected) .urlbarView-action {
        color: #${primary} !important;
      }

      .urlbarView-row-inner:selected .urlbarView-action {
        color: #${background-darker} !important;
      }

      .searchbar-engine-one-off-item[selected] {
        background-color: #${primary} !important;
      }

      button[autofocus], button[type="submit"], button[default], button.primary {
        background-color: #${primary} !important;
      }

      menupopup {
        --panel-background-color: #${background} !important;
        --panel-text-color: #${foreground} !important;
        font-family: "${font}" !important;
      }

      menuitem {
        color: #${foreground} !important;
      }

      #star-button[starred] {
        fill: #${primary} !important;
      }

      .toolbarbutton-badge {
        background-color: #${background-darker} !important;
        color: #${foreground} !important;
      }

      #downloads-button[attention="success"] > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-icon,
      #downloads-button[attention="success"] > .toolbarbutton-badge-stack > #downloads-indicator-start-box > #downloads-indicator-start-image,
      #downloads-indicator-finish-image {
        fill: #${primary} !important;
        stroke: #${primary} !important;
      }

      #downloads-indicator-progress-inner {
        background: conic-gradient(#${primary} var(--download-progress-pcent), transparent var(--download-progress-pcent)) !important;
      }

      #urlbar .search-panel-one-offs-header-label {
        color: #${foreground} !important;
        opacity: 1.0 !important;
      }

      #commonDialog {
        background: #${background-darker} !important;
      }

      .downloadProgress::-moz-progress-bar {
        background-color: #${primary} !important;
      }

    ''
  }

  ${cfg.theme.extraUserChrome}
''
