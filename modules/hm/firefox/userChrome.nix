{
  cfg,
  lib,
  pkgs,
  self,
}: let
  inherit (cfg.theme.colors) background-darker background foreground primary border;
  inherit (cfg.theme) font;

  userChrome = self.packages.${pkgs.stdenv.hostPlatform.system}.userChrome.override {
    backgroundDarker = background-darker;
    inherit background border font;
  };
in ''
  ${lib.optionalString cfg.extensions.simplefox.enable (builtins.readFile userChrome)}

  * {
    font-family: "${font}" !important;
  }

  :root {
    --toolbar-bgcolor: #${background} !important;
    --toolbarbutton-icon-fill: #${foreground} !important;

    --system-color-accent: #${primary} !important;
    --system-color-accent-hover: #${primary} !important;
    --system-color-accent-active: #${primary} !important;

    --arrowpanel-background: #${background} !important;
    --arrowpanel-color: #${foreground} !important;
    --arrowpanel-dimmed: #${background} !important;
    --arrowpanel-border-color: #${border} !important;

    --urlbar-box-bgcolor: #${background} !important;
    --urlbar-box-text-color: #${foreground} !important;

    --checkbox-checked-bgcolor: #${primary} !important;
    --checkbox-checked-hover-bgcolor: #${primary} !important;

    --button-primary-bgcolor: #${primary} !important;
    --button-primary-hover-bgcolor: #${primary} !important;
    --button-primary-active-bgcolor: #${primary} !important;
    --button-primary-color: #${background-darker} !important;

    --in-content-page-background: #${background-darker} !important;

    --in-content-button-background: #${background} !important;
    --in-content-button-background-hover: #${background} !important;
    --in-content-button-background-active: #${background} !important;
    --in-content-button-text-color: #${foreground} !important;

    --in-content-primary-button-background: #${primary} !important;
    --in-content-primary-button-background-hover: #${primary} !important;
    --in-content-primary-button-text-color: #${background-darker} !important;

    --focus-outline-color: #${primary} !important;

    --lwt-text-color: #${foreground} !important;
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

  #urlbar-background {
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

  html|button[autofocus], html|button[type="submit"], xul|button[default], button.primary {
    background-color: #${primary} !important;
  }

  menupopup {
    --panel-background: #${background} !important;
    --panel-color: #${foreground} !important;
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

  ${cfg.theme.extraUserChrome}
''
