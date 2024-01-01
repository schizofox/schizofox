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

  :root {
    --toolbar-bgcolor: #${background} !important;

    --system-color-accent: #${primary} !important;
    --system-color-accent-hover: #${primary} !important;
    --system-color-accent-active: #${primary} !important;

    --arrowpanel-background: #${background} !important;

    --urlbar-box-bgcolor: #${background} !important;
    --urlbar-box-text-color: #${foreground} !important;

    --checkbox-checked-bgcolor: #${primary} !important;
    --checkbox-checked-hover-bgcolor: #${primary} !important;

    --button-primary-bgcolor: #${primary} !important;
    --button-primary-hover-bgcolor: #${primary} !important;
    --button-primary-active-bgcolor: #${primary} !important;
    --button-primary-color: #${background-darker} !important;
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

  menubar > menu[open] {
    border-bottom-color: #${primary} !important;
  }

  .urlbarView-row[selected] {
    background-color: #${primary} !important;
  }

  .urlbarView-row[source="bookmarks"] > .urlbarView-row-inner > .urlbarView-no-wrap > .urlbarView-favicon, #urlbar-engine-one-off-item-bookmarks {
    fill: #${primary} !important;
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

  ${cfg.theme.extraUserChrome}
''
