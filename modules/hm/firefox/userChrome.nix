{
  cfg,
  lib,
  pkgs,
  self,
}: let
  inherit (cfg.theme.colors) background-darker background foreground primary border;
  userChrome = self.packages.${pkgs.stdenv.hostPlatform.system}.userChrome.override {
    backgroundDarker = background-darker;
    inherit background border;
    inherit (cfg.theme) font;
  };
in ''
  ${lib.optionalString cfg.extensions.simplefox.enable (builtins.readFile userChrome)}

  :root {
    --toolbar-bgcolor: #${background} !important;

    --system-color-accent: #${primary} !important;
    --system-color-accent-hover: #${primary} !important;
    --system-color-accent-active: #${primary} !important;
  }

  #navigator-toolbox {
    background: #${background-darker} !important;
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
  }

  menubar > menu[open] {
    border-bottom-color: #${primary} !important;
  }

  ${cfg.theme.extraUserChrome}
''
