{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkPackageOption mkOption literalExpression;
  inherit (lib.types) anything attrsOf enum functionTo package;
  jsonFormat = pkgs.formats.json {};
in {
  options.programs.schizofox = {
    enable = mkEnableOption "Schizofox";
    package = mkPackageOption pkgs "firefox-esr-140-unwrapped" {
      example = "firefox-esr-unwrapped";
    };

    wrapFirefox = mkOption {
      type = functionTo (functionTo package);
      default = pkgs.wrapFirefox;
      defaultText = literalExpression "pkgs.wrapFirefox";
      description = ''
        Function wrapping an unwrapped Firefox package with Firefox wrapper
        arguments. Defaults to the nixpkgs wrapper; a compatible Adifox adapter
        may be supplied instead.
      '';
    };

    wrapperArgs = mkOption {
      type = attrsOf anything;
      default = {};
      example = literalExpression ''
        {
          nativeMessagingHosts = [pkgs.firefoxpwa];
          extraPolicies = {DisablePocket = true;};
        }
      '';
      description = ''
        Extra arguments for the selected Firefox wrapper. Schizofox's
        generated Autoconfig file is prepended to extraPrefsFiles; extraPolicies
        override individual Schizofox policies.
      '';
    };

    prefName = mkOption {
      type = enum ["pref" "lockPref"];
      default = "pref";
      description = ''
        Autoconfig preference function. pref sets a default that a profile may
        override; lockPref prevents users from changing generated preferences.
      '';
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

        Firefox only supports int, bool, and string preference values.
        Other JSON-compatible values in programs.schizofox.settings are
        serialized as JSON strings.
      '';
    };
  };
}
