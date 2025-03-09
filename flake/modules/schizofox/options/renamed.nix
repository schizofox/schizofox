{lib, ...}: let
  inherit (lib.modules) mkRenamedOptionModule;
in {
  imports = [
    (mkRenamedOptionModule ["programs" "schizofox" "bookmarks"] ["programs" "schizofox" "misc" "bookmarks"])

    (mkRenamedOptionModule ["programs" "schizofox" "theme" "extraCss"] ["programs" "schizofox" "theme" "extraUserChrome"])
    (mkRenamedOptionModule ["programs" "schizofox" "theme" "extraCssContent"] ["programs" "schizofox" "theme" "extraUserContent"])
    (mkRenamedOptionModule ["programs" "schizofox" "misc" "extraUserContent"] ["programs" "schizofox" "theme" "extraUserContent"])
    (mkRenamedOptionModule ["programs" "schizofox" "theme" "background-darker"] ["programs" "schizofox" "theme" "colors" "background-darker"])
    (mkRenamedOptionModule ["programs" "schizofox" "theme" "background"] ["programs" "schizofox" "theme" "colors" "background"])
    (mkRenamedOptionModule ["programs" "schizofox" "theme" "foreground"] ["programs" "schizofox" "theme" "colors" "foreground"])

    (mkRenamedOptionModule ["programs" "schizofox" "theme" "simplefox"] ["programs" "schizofox" "extensions" "simplefox"])
    (mkRenamedOptionModule ["programs" "schizofox" "theme" "darkreader"] ["programs" "schizofox" "extensions" "darkreader"])

    (mkRenamedOptionModule ["programs" "schizofox" "misc" "drmFix"] ["programs" "schizofox" "misc" "drm" "enable"])
  ];
}
