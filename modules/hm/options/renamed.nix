{lib, ...}: let
  inherit (lib) mkRenamedOptionModule;
in {
  imports = [
    (mkRenamedOptionModule ["programs" "schizofox" "bookmarks"] ["programs" "schizofox" "misc" "bookmarks"])
    (mkRenamedOptionModule ["programs" "schizofox" "theme" "extraCss"] ["programs" "schizofox" "theme" "extraUserChrome"])
    (mkRenamedOptionModule ["programs" "schizofox" "theme" "extraCssContent"] ["programs" "schizofox" "theme" "extraUserContent"])
  ];
}
