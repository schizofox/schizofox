{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str bool listOf;
  inherit (lib.types.ints) unsigned;

  cfg = config.programs.schizofox.security;
in {
  options.programs.schizofox.security = {
    javascript.enable = mkEnableOption {
      type = bool;
      default = true;
      example = false;
      description = ''
        JavaScript support in Schizofox. This defaults to true as many websites
        rely on Javascript to function properly, but it can be disabled for
        additional security and privacy purposes.

        [Noscript]: https://addons.mozilla.org/en-US/firefox/addon/noscript/

        ::: {.note}
        When Javascript is enabled, we encourage you to use something like [Noscript]
        to *selectively* allow Javascript on domains that you trust. Enabling Javascript
        should be considered a security flaw!
        :::
      '';
    };

    userAgent = mkOption {
      type = str;
      default = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:140.0) Gecko/20100101 Firefox/140.0";
      description = "Spoofed user agent string to be sent";
      example = ''
        ::: {.tip}
        **Some other user agents**
        Mozilla/5.0 (X11; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
        Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
        Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:110.0) Gecko/20100101 Firefox/110.0
        Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0
        Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)
        :::
      '';
    };

    sanitizeOnShutdown = {
      enable = mkOption {
        type = bool;
        default = false;
        example = true;
        description = ''
          Whether to clear cookies, history, and other data during shutdown. This option
          defaults to false to help with user experience and data loss, but it should be
          considered a security risk!

          ::: {.tip}
          Tip: use ctrl+i";
          :::
        '';
      };

      sanitize = {
        cache = mkOption {
          type = bool;
          default = cfg.sanitizeOnShutdown.enable;
          description = "Whether to clear Firefox cache on shutdown";
        };

        downloads = mkOption {
          type = bool;
          default = cfg.sanitizeOnShutdown.enable;
          description = "Whether to clear Firefox downloads history on shutdown";
        };

        formdata = mkOption {
          type = bool;
          default = cfg.sanitizeOnShutdown.enable;
          description = "Whether to clear Firefox form data on shutdown";
        };

        history = mkOption {
          type = bool;
          default = cfg.sanitizeOnShutdown.enable;
          description = "Whether to clear Firefox history on shutdown";
        };

        siteSettings = mkOption {
          type = bool;
          default = cfg.sanitizeOnShutdown.enable;
          description = "Whether to clear Firefox site settings on shutdown";
        };
      };
    };

    enableCaptivePortal = mkEnableOption ''
      Firefox captive portal detection.

      See https://support.mozilla.org/en-US/kb/captive-portal on implications
      of enabling this feature.
    '';

    noSessionRestore = mkOption {
      type = bool;
      default = false;
      example = true;
      description = ''
        Disable session restore on startup. This will will get rid of the
        "Restore tabs" button on startup if Firefox has exited unexpectedly.
      '';
    };

    maxTabsUndo = mkOption {
      type = unsigned;
      default =
        if cfg.sanitizeOnShutdown.sanitize.history
        then 0
        else 25;
      defaultText = 25;
      description = ''
        How many tabs should you be able to restore. This is problematic
        because it persists closed tabs between browser launches even with
        history sanitization.
      '';
    };

    wrapWithProxychains = mkOption {
      type = bool;
      default = false;
      example = true;
      description = ''
        Wrap schizofox desktop entry with proxychains-ng.

        See https://github.com/rofl0r/proxychains-ng for more details.
      '';
    };

    sandbox = {
      enable = mkOption {
        type = bool;
        default = true;
        example = false;
        description = "runtime sandboxing with NixPak";
      };

      extraBinds = mkOption {
        type = listOf str;
        default = [];
        example = ["/home/\${username}/.config/tridactyl"];
        description = "Extra, read-only, paths to bind-mount into the sandbox.";
      };

      allowFontPaths = mkOption {
        type = bool;
        default = true;
        example = false;
        description = "Whether to add {file}`/etc/fonts` to the nixpak sandbox";
      };
    };

    webRTC = {
      disable = mkOption {
        type = bool;
        default = false;
        example = true;
        description = ''
          Whether to disable WebRTC in Firefox.

          WebRTC  is a technology that enables peer-to-peer communication
          directly within web browsers without the need for plugins or
          external applications. It supports video, voice, and generic data
          sharing between peers, which is highly useful for applications like
          video conferencing, file sharing, and live streaming.

          Disabling WebRTC _might_ prevent IP leaks and other privacy issues.
        '';
      };
    };
  };

  config.assertions = [
    {
      assertion = !lib.isBool cfg.sanitizeOnShutdown;
      message = ''
        The 'programs.schizofox.security.sanitizeOnShutdown' option has been
        replaced with 'programs.schizofox.security.sanitizeOnShutdown.enable'
        and setting it to a bool is no longer supported.
      '';
    }
  ];
}
