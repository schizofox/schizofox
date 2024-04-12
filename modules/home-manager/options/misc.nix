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
      example = literalExpression ''
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
      We *always* recommend legally obtaining content those platforms provide.
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
  };
}
