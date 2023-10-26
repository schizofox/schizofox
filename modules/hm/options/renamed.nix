{lib, ...}: let
  inherit (lib) mkRenamedOptionModule;
in {
  imports = [
    (mkRenamedOptionModule ["programs" "schizofox" "bookmarks"] ["programs" "schizofox" "misc" "bookmarks"])
  ];
}
