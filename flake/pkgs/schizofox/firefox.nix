{
  makeDesktopItem,
  wrapFirefox,
  firefox-unwrapped,
  policies,
  wrapWithProxychains,
  files,
  ...
}: let
  logo = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/schizofox/assets/main/logo/logo.png";
    sha256 = "1wjzivdmppbzrwdxhza5dzzljl3z59vfgggxim9xjb2rzr0wqyyf";
  };

  desktopItem = makeDesktopItem {
    name = "Schizofox";
    desktopName = "Schizofox";
    genericName = "Web Browser";
    exec =
      if wrapWithProxychains
      then "proxychains4 schizofox %U"
      else "schizofox %U";
    icon = "${logo}";
    terminal = false;
    categories = ["Network" "WebBrowser"];
    mimeTypes = ["text/html" "text/xml"];
  };

  wrappedFox = wrapFirefox firefox-unwrapped {
    extraPolicies = policies;
    extraPrefs = files."user.js".text;
  };

  finalPackage = wrappedFox.overrideAttrs (old: {
    buildCommand =
      (old.buildCommand or "")
      + ''
        rm -rf $out/share/applications/*
        install -D ${desktopItem}/share/applications/Schizofox.desktop $out/share/applications/Schizofox.desktop
        makeWrapper $out/bin/firefox $out/bin/schizofox
      '';
  });
in
  finalPackage
