{
  lib,
  config,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption literalExpression;
  inherit (lib.types) enum listOf attrs bool str nullOr;

  cfg = config.programs.schizofox;
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

    aiRuntime = {
      enable = mkEnableOption ''
        Firefox AI Runtime
        This includes stuff like website summaries when hovering over a link

        ::: {.note}
        LLM inference is done completely on the client, so there is no data
        or privacy risk.
        Model itself gets downloaded from model-hub.mozilla.org
        :::
      '';
      url = mkOption {
        type = str;
        default =
          if cfg.misc.aiRuntime.enable
          then "https://model-hub.mozilla.org/"
          else "http://127.0.0.1/";
        defaultText = "http://127.0.0.1/";
        example = literalExpression "file://$${relative/path/to/startpage.html}";
        description = "An URL or an absolute path to your Firefox startpage";
      };
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

    customMozillaFolder = {
      enable = mkEnableOption ''
        a custom .mozilla folder for storing browser data.

        You may want this so it doesn't clash with other firefox installations.
      '';
      path = let
        # the extra check code has been taken from github.com/nix-community/disko
        # it was, as far as I can tell written by Lassulus <https://github.com/lassulus>
        # the project is licensed under MIT License,
        # which can be found at https://github.com/nix-community/disko/blob/master/LICENSE
        # Copyright (c) 2018, 2019, 2022–2024 Nix community projects
        check = x: let
          # The filter is used to normalize paths, i.e. to remove duplicated and
          # trailing slashes.  It also removes leading slashes, thus we have to
          # check for "/" explicitly below.
          xs = lib.filter (s: lib.stringLength s > 0) (lib.splitString "/" x);
        in
          lib.isString x && (x == "/" || lib.length xs > 0) && lib.substring 0 1 x == "/";
      in
        mkOption {
          type = lib.types.addCheck lib.types.str check;
          default = "/.schizofox/mozilla";
          example = "/.local/share/schizofox/mozilla";
          description = "A relative path, from the users home directory, to the folder that will contain schizofoxes data and configuration";
        };
    };
  };
  config.assertions = [
    {
      assertion = !(!cfg.security.sandbox.enable && cfg.misc.customMozillaFolder.enable);
      message = ''
        To use a custom .mozilla folder sanboxing must be enabled.
        Enable sandboxing using 'programs.schizofox.security.sandbox.enable'
      '';
    }
  ];
}
