{lib, ...}: let
  inherit (lib) mkOption mkEnableOption types;
in {
  options.programs.schizofox.security = {
    userAgent = mkOption {
      type = types.str;
      default = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101 Firefox/110.0";
      description = "Spoof user agent";
      example = ''
        **Some other user agents**
        Mozilla/5.0 (X11; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
        Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
        Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
        Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0
      '';
    };

    sanitizeOnShutdown = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Clear cookies, history and other data on shutdown.
        Disabled on default, because it's quite annoying. Tip: use ctrl+i";
      '';
    };

    enableCaptivePortal = mkEnableOption "captive portal";

    noSessionRestore = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Disable session restore on startup. This will will get rid of the
        "Restore tabs" button on startup if Firefox has exited unexpectedly.
      '';
    };

    wrapWithProxychains = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Wrap schizofox desktop entry with proxychains-ng.

        See https://github.com/rofl0r/proxychains-ng for more details.
      '';
    };

    sandbox = mkOption {
      type = types.bool;
      default = true;
      example = true;
      description = "Enable runtime sandboxing with NixPak";
    };
  };
}
