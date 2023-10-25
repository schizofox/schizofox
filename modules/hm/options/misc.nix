{lib, ...}: let
  inherit (lib) mkOption types literalExpression;
in {
  options.programs.schizofox.misc = {
    bookmarks = mkOption {
      type = with types; listOf attrs;
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

    drmFix = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Enable DRM for websites that require it, such as Netflix and Spotify.
        We *always* recommend legally obtaining content those platforms provide.
      '';
    };

    disableWebgl = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Force WebGL to be disabled.
        Do note that it'll break plenty of websites that mess with the canvas (practically anything at this point)
      '';
    };

    startPageURL = mkOption {
      type = with types; nullOr str;
      default = null;
      example = literalExpression "file://$${relative/path/to/startpage.html}";
      description = "An URL or an absolute path to your Firefox startpage";
    };

    extraUserContent = mkOption {
      type = types.str;
      default = "";
      example = ''
        @-moz-document domain("example.com") {
          body {
            background-color: red;
          }
        }
      '';
      description = "Extra css for userContent.css";
    };
  };
}
