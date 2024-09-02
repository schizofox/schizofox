{lib, ...}: let
  inherit (lib.options) mkOption mkEnableOption literalExpression;
  inherit (lib.types) enum listOf attrs bool str nullOr;
in {
  options.programs.schizofox.misc = {
    startPageURL = mkOption {
      type = nullOr str;
      default = null;
      example = literalExpression "file://$${relative/path/to/startpage.html}";
      description = "An URL or an absolute path to your Firefox startpage";
    };

    displayBookmarksInToolbar = mkOption {
      type = enum ["always" "never" "newtab"];
      default = "never";
    };

    bookmarks = mkOption {
      type = listOf attrs;
      default = [];
      description = "List of bookmarks to add to your Schizofox configuration";
      example = ''
        [
          {
            Title = "Example";
            URL = "https://example.com";
            Favicon = "https://example.com/favicon.ico";
            Placement = "toolbar";
            Folder = "FolderName";
          }
        ]
      '';
    };

    drm.enable = mkEnableOption ''
      DRM for websites that require it, such as Netflix and Spotify.

      ::: {.warning}
      We *always* recommend legally obtaining content those platforms
      provide.
      :::
    '';

    contextMenu.enable = mkEnableOption ''
      right-click context menu that is disabled by default.

      ::: {.note}
      Setting this to true fixes an issue where a second
      context menu appears on top of the YouTube one, which
      was introduced by a security policy that disallows
      web-pages from hijacking the context menu.
      :::
    '';

    disableWebgl = mkOption {
      type = bool;
      default = false;
      example = true;
      description = ''
        Force WebGL to be disabled.

        Do note that it'll break plenty of websites that mess
        with the canvas (practically anything at this point)
      '';
    };

    firefoxSync = mkEnableOption "Firefox Sync";

    speechSynthesisSupport = mkEnableOption ''
      speech synthesis support in Firefox.

      ::: {.note}
      This is enabled by default in wrapFirefox due to accessibility
      reasons, however, those who need rely on this feature may disable
      speech synthesis support to reduce the closure size by a significant
      amount
      :::
    '';
  };
}
