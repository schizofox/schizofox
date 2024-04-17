{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkPackageOption mkOption literalExpression;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (lib.types) attrsOf;
  jsonFormat = pkgs.formats.json {};
in {
  options.programs.schizofox = {
    enable = mkEnableOption "Schizofox";
    package = mkPackageOption pkgs "firefox-esr-115-unwrapped" {
      example = "firefox-esr-unwrapped";
    };
    executableName = mkOption {
      type = lib.types.str;
      default = "firefox";
      example = "floorp";
    };
    configPath = mkOption {
      type = lib.types.str;
      default =
        if isDarwin
        then "Library/Application Support/Firefox"
        else ".mozilla/firefox";
      example = ".mozilla/firefox";
    };

    settings = mkOption {
      type = attrsOf (jsonFormat.type
        // {
          description = "Firefox preference (int, bool, string, and also attrs, list, float as a JSON string)";
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
        preferences, but `programs.schizofox.settings will
        automatically convert all other JSON-compatible values
        into strings.
      '';
    };
  };
}
