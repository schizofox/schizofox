{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkPackageOption mkOption literalExpression;
  inherit (lib.types) submodule attrsOf listOf package anything;
  jsonType = (pkgs.formats.json {}).tyepe;
in {
  options.programs.schizofox = {
    enable = mkEnableOption "Schizofox";
    package = mkPackageOption pkgs "firefox-esr-115-unwrapped" {
      example = "firefox-esr-unwrapped";
    };

    settings = mkOption {
      type = attrsOf (jsonType
        // {
          description = ''
            Firefox preference (int, bool, string, and also attrs, list, float
            as a JSON string)
          '';
        });
      default = {};
      example = literalExpression ''
        {
          "browser.startup.homepage" = "https://nixos.org";
          "browser.search.region" = "GB";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";
          "browser.bookmarks.showMobileBookmarks" = true;
          "browser.newtabpage.pinned" = [{
            title = "NixOS";
            url = "https://nixos.org";
          }];
        }
      '';
      description = ''
        Attribute set of Firefox preferences.

        Firefox only supports int, bool, and string types for
        preferences, but {option}`programs.schizofox.settings` will
        automatically convert all other JSON-compatible values
        into strings.
      '';
    };

    extraWrapperArgs = mkOption {
      default = {};
      type = submodule {
        freeformType = attrsOf anything;

        # Freeform options are initially not validated by a schema
        # so we are able to pass anything we wish to them. Below
        # options are the ones we **want** type-checked so that the
        # end-user does not hit obscure errors due to type mismatches.
        options = {
          nativeMessagingHosts = mkOption {
            default = [];
            example = "[pkgs.tridactyl-native]";
            type = listOf package;
            description = ''
              List of packages that provide native messaging hosts.
            '';
          };
        };
      };

      description = ''
        Additional wrapper arguments to be passed to pkgs.wrapFirefox.

        Do keep in mind that this is a freeform module, which means you
        are able to pass virtually any attribute that you wish to and it
        will be passed to wrapFirefox verbatim.

        This can be used to set options that do not have configuration
        interfaces in the Schizofox module, but it must also be used with
        great care.

        Please see the documentation for the `wrapFirefox` function in
        the nixpkgs manual.
      '';
    };
  };
}
