{
  cfg,
  lib,
  ...
}:
with lib; let
  # Makes the given value unless the given predicate is true.
  mkUnless = pred: val: (mkIf (! pred) val);
  recursiveMerge = attrList: let
    f = attrPath:
      zipAttrsWith (
        n: values:
          if tail values == []
          then head values
          else if all isList values
          then unique (concatLists values)
          else if all isAttrs values
          then f (attrPath ++ [n]) values
          else last values
      );
  in
    f [] attrList;

  wavefox = cfg.theme.wavefox;
  mode =
    if cfg.theme.darkTheme
    then "DarkTheme"
    else "LightTheme";
in
  recursiveMerge [
    {
      "browser.tabs.inTitlebar" = lib.mkDefault 1;
      "layout.css.has-selector.enabled" = true;
      "svg.context-properties.content.enabled" = true;
      "userChrome.Style.ThirdParty.Enabled" = true;

      # has to be 0 when bottom tabs

      "gfx.webrender.all" = true;
      "userChrome.Tabs.Option${toString wavefox.tabs.style}.Enabled" = true;
      "browser.theme.windows.accent-color-in-tabs.enabled" = wavefox.windowAccentColor;
      "toolkit.zoomManager.zoomValues" = ".8,.90,.95,1,1.1,1.2";
      "browser.uidensity" = 1;

      "userChrome.${mode}.Tabs.Borders.Enabled" = wavefox.tabs.borders;
      "userChrome.${mode}.Tabs.Shadows.Saturation.${wavefox.tabs.shadowSaturation}.Enabled" = true;
      "userChrome.TabSeparators.Saturation.${wavefox.tabs.separatorSaturation}.Enabled" = true;

      "userChrome.Menu.Size.${wavefox.menu.density}.Enabled" = true;
      "userChrome.Menu.Icons.${wavefox.menu.icons}.Enabled" = true;
      "userChrome.Tabs.Pinned.Width.${wavefox.tabs.pinnedWidth}Offset.Enabled" = true;
      "userChrome.Tabs.SelectedTabIndicator.Enabled" = wavefox.tabs.selectedIndicator;

      "browser.startup.homepage" =
        if cfg.misc.startPageURL != null
        then "${cfg.misc.startPageURL}"
        else "";
    }

    (mkUnless (wavefox.transparency == "None") {
      "userChrome.Linux.Transparency.${wavefox.transparency}.Enabled" = true;
    })
    (mkUnless (wavefox.tabs.oneline == "Disable") {
      "userChrome.OneLine.${wavefox.tabs.oneline}.Enabled" = true;
    })
    (mkIf wavefox.tabs.bottom {
      # required for bottom tab layout
      "browser.tabs.inTitlebar" = lib.mkForce 0;
      "userChrome.Tabs.TabsOnBottom.Enabled" = true;
    })

    (import ./security.nix {inherit cfg;})
    (import ./qof.nix)
  ]
