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

      ::: {.warning}
      We *always* recommend legally obtaining content those platforms
      provide.
      :::
    '';

    contextMenu.enable = mkEnableOption ''
      right-click context menu that is disabled by default.

      ::: {.note}
      Fixes the issue where a second context menu appears
      on top of the YouTube one.
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
    translate.enable =
      mkEnableOption ''
        webpage translation.

        ::: {.note}
        Web page translation is done completely on the client, so there is no data
        or privacy risk.
        :::

        If you only want to disable the popup, you can set the pref
        `browser.translations.automaticallyPopup` in Schizofox'
        {option}`programs.schizofox.settings`
      ''
      // {default = true;};
    showHomeButton = mkEnableOption "displaying Home Button in the toolbar";
  };
}
