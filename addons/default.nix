{
  cfg,
  darkreader,
  ...
}: let
  mkForceInstalled = extensions:
    builtins.mapAttrs
    (name: cfg: {installation_mode = "force_installed";} // cfg)
    extensions;
  reader = darkreader.override {
    background = cfg.background;
    foreground = cfg.foreground;
  };
in
  mkForceInstalled {
    "addon@darkreader.org".install_url = "file://${reader}/release/darkreader-firefox.xpi";
    "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
    "{36bdf805-c6f2-4f41-94d2-9b646342c1dc}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/export-cookies-txt/latest.xpi";
    "{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
    "{b86e4813-687a-43e6-ab65-0bde4ab75758}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
    "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
    "{531906d3-e22f-4a6c-a102-8057b88a1a63}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/single-file/latest.xpi";
    "{c607c8df-14a7-4f28-894f-29e8722976af}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi";
    "skipredirect@sblask".install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
    "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
    "smart-referer@meh.paranoid.pk".install_url = "https://github.com/catppuccin/firefox/releases/download/old/smart-referer.xpi";
  }
