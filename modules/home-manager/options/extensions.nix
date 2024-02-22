{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types literalExpression mkEnableOption;

  cfg = config.programs.schizofox.extensions;

  # extensions that will be enabled by default
  defaultExtensions = {"uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";};

  # extensions that will be installed only at user's explicit request
  extraExtensions = {
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

  # a full list of extension to be installed
  extensions = defaultExtensions // lib.optionalAttrs cfg.enableExtraExtensions extraExtensions;
in {
  options.programs.schizofox.extensions = {
    simplefox = {
      enable = mkEnableOption ''
        Simplefox, a userstyle theme for a minimalist and keyboard centered Firefox
      '';

      showUrlBar = mkEnableOption "show the URL bar on hover";
    };

    darkreader.enable =
      mkEnableOption ''
        Dark mode on all sites (patched to match overall theme)
      ''
      // {default = true;}; # no escape

    # those extensions will be installed by default
    # can be an empty set to disable
    defaultExtensions = mkOption {
      type = types.attrs;
      default = extensions;
      example = literalExpression "{}";
      description = ''
        A set of addons that will be installed by default. Can be set to `{}` to avoid installing
        any of the default addons.
      '';
    };

    enableExtraExtensions = mkEnableOption "the installation of extra extensions by default. ";

    # extraExtensions include extensions that were previously in the defaults, but are disabled by default
    extraUserExtensions = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Extra extensions that will be installed only at user's explicit request. Can be left as the default `{}` to only
        install extensions provided by the `defaultExtensions` option.
      '';

      example = literalExpression ''
        {
          "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
        }
      '';
    };
  };
}
