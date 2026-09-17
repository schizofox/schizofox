{
  inputs,
  tack,
}: {
  pkgs,
  lib,
  config,
}: {mode}: let
  validMode = builtins.elem mode ["nixos" "home-manager"];
  cfg = config.programs.schizofox;
  usingNixosModule = mode == "nixos";
  maybeTheme = opt: lib.findFirst builtins.isNull opt.package [opt opt.package];
  cursorTheme =
    if mode == "home-manager"
    then maybeTheme config.home.pointerCursor
    else null;
  iconTheme =
    if mode == "home-manager"
    then maybeTheme config.gtk.iconTheme
    else null;
  gtkTheme =
    if mode == "home-manager"
    then maybeTheme config.gtk.theme
    else null;
  nixpakLib = inputs.nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };
  searxRandomizerPkg = tack.searx-randomizer.packages.${pkgs.system}.default;
  darkreaderPkg = pkgs.callPackage ./darkreader/package.nix {};
  userChromePkg = pkgs.callPackage ./simplefox/userChrome.nix {};
  userContentPkg = pkgs.callPackage ./simplefox/userContent.nix {};
  generated = import ./files.nix {
    wrappedPackage = wrappedPackage;
    inherit
      cfg
      darkreaderPkg
      gtkTheme
      iconTheme
      cursorTheme
      lib
      nixpakLib
      pkgs
      searxRandomizerPkg
      userChromePkg
      userContentPkg
      usingNixosModule
      ;
  };
  wrappedPackage = pkgs.callPackage ./firefox.nix {
    inherit cfg darkreaderPkg lib;
    files = generated.files;
  };
in
  assert validMode; {
    package = generated.package;
    inherit (generated) files searx-randomizer-unit;
  }
