{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mdDoc mkOption literalExpression types;
  jsonFormat = pkgs.formats.json { };
in {
  options.programs.schizofox = {
    enable = mkEnableOption (mdDoc "Schizophrenic Firefox ESR setup for the delusional");

    package = mkPackageOption pkgs "firefox-esr-115-unwrapped" {
      example = "firefox-esr-unwrapped";
    };
     settings = mkOption {
              type = types.attrsOf (jsonFormat.type // {
                description =
                  "Firefox preference (int, bool, string, and also attrs, list, float as a JSON string)";
              });
              default = { };
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
                preferences, but home-manager will automatically
                convert all other JSON-compatible values into strings.
              '';
            };

  };
}
