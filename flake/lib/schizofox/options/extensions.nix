{lib, ...}: let
  inherit (lib.options) mkOption literalExpression mkEnableOption;
  inherit (lib.types) attrs bool;
in {
  options.programs.schizofox.extensions = {
    enableDefaultExtensions = mkEnableOption ''
      default extensions provided by Schizofox.
    '';

    enableExtraExtensions = mkEnableOption ''
      extra extensions added to the user configuration.
    '';

    simplefox = {
      enable = mkEnableOption ''
        Simplefox, an userstyle theme for Firefox minimalist and Keyboard centered.
      '';

      showUrlBar = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to show the URL bar on hover.
        '';
      };
    };

    darkreader.enable = mkEnableOption ''
      Dark mode on all websites with a patched version of DarkReader
      to conform to your Schizofox theming options.

      ::: {.note}
      This contributes to your browser fingerprinting, and is therefore
      disabled by default
      :::
    '';

    defaultExtensions = mkOption {
      readOnly = true;
      internal = true;
      type = attrs;
      default = {
        "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };

      description = ''
        A set of addons that will be installed by default. Can be set to `{}` to avoid
        installing any of the default addons. The behaviour of `defaultExtensions` can
        be disabled by toggling the {option}`enableDefaultExtensions` option under
        {option}`programs.schizofox.extensions`.

        ::: {.note}
        Schizofox only provides uBlock Origin out of the box.
        :::
      '';
    };

    extraExtensions = mkOption {
      type = attrs;
      default = {};
      description = ''
        Extra extensions that will be installed in addition to default extensions.
        Any extensions that are added here will be merged with the attribute set
        provided by `defaultExtensions`.

        ::: {.warning}
        Remember to keep your extensions list brief, as unique extension combinations
        will also contribute to your fingerprinting
        :::
      '';

      example = literalExpression ''
        {
          "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/export-cookies-txt/latest.xpi";
          "{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          "{b86e4813-687a-43e6-ab65-0bde4ab75758}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
          "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
          "{531906d3-e22f-4a6c-a102-8057b88a1a63}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/single-file/latest.xpi";
          "{c607c8df-14a7-4f28-894f-29e8722976af}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi";
          "skipredirect@sblask".install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
          "smart-referer@meh.paranoid.pk".install_url = "https://addons.mozilla.org/firefox/downloads/latest/smart-referer/latest.xpi";
          "7esoorv3@alefvanoon.anonaddy.me".install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
        }
      '';
    };
  };
}
