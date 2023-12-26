{lib, ...}: let
  inherit (lib) mkOption types literalExpression mkEnableOption;
in {
  options.programs.schizofox.extensions = {
    defaultExtensions = mkOption {
      type = types.attrs;
      default = {
        "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/export-cookies-txt/latest.xpi";
        "{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
        "{b86e4813-687a-43e6-ab65-0bde4ab75758}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
        "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
        "{531906d3-e22f-4a6c-a102-8057b88a1a63}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/single-file/latest.xpi";
        "{c607c8df-14a7-4f28-894f-29e8722976af}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi";
        "skipredirect@sblask".install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
        "smart-referer@meh.paranoid.pk".install_url = "https://addons.mozilla.org/firefox/downloads/latest/smart-referer/latest.xpi";
        "7esoorv3@alefvanoon.anonaddy.me".install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
      };

      example = literalExpression "{}";

      description = ''
        A set of addons that will be installed by default. Can be set to `{}` to avoid installing
        any of the default addons.
      '';
    };

    simplefox = {
      enable = mkEnableOption ''
        A Userstyle theme for Firefox minimalist and Keyboard centered.
      '';

      showUrlBar = mkEnableOption ''
        Show the URL bar on hover.
      '';
    };

    # TODO: patchDefaultColors bool option
    darkreader.enable =
      mkEnableOption ''
        Dark mode on all sites (patched to match overall theme)
      ''
      // {default = true;}; # no escape

    extraExtensions = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Extra extensions that will be installed in addition to default extensions. Will be merged
        with the attribute set provided by `defaultExtensions`.
      '';
      example = literalExpression ''
        {
          "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
        }
      '';
    };
  };
}
