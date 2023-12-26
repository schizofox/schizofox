<p align="center">
<img src="https://github.com/schizofox/assets/blob/main/logo/logo.png" alt="screenshot" width="200" align="center" />
</p>

# Schizofox

_our goal is to get on the CIA watchlist_

## About

Schizofox started as a part of [Sioodmy's dotfiles](https://github.com/sioodmy/dotfiles) and was adapted by [NotAShelf](https://github.com/notashelf/nyx) for future use. As such, it has been moved into its own standalone flake and eventually an organization.

Compared to other browsers/configurations, I would say it's pretty _schizophrenic_, but it is also daily driveable so some compromises were made. Keep in mind that any "super ultra privacy friendly firefox config" will make you stick out and won't protect you from fingerprinting; sadly there is no escape from that. If you are really looking for security, look into the Tor browser.

Fun fact: clearing cookies is just a waste of time with cookie isolation enabled (just use temporary containers if you need to)

### Notable Features

- Declarative theming. Just specify 3 colors and your font of choice and nix will do the rest (userChrome.css and darkreader config)
- Declarative extension installation with the home-manager module
- NixPak wrapped package
- Extensive & modular configuration

### Contributing

Schizofox is still beta software, and breaking changes are to be expected.

Make sure to submit an issue in case anything breaks, or make a PR if you know how to fix said issue.

## 💛 Donate

If you would like to support us, you may use Liberapay to do so:

<a href="https://liberapay.com/schizofox/donate"><img src="https://img.shields.io/liberapay/patrons/notashelf.svg?logo=liberapay?color=e5c890&labelColor=303446&style=for-the-badge"></a>

## Configuration

```nix
imports = [ inputs.schizofox.homeManagerModule ];
programs.schizofox = {
  enable = true;

  theme = {
    background-darker = "181825";
    background = "1e1e2e";
    foreground = "cdd6f4";
    font = "Lexend";
    simplefox.enable = true;
    darkreader.enable = true;
    extraUserChrome = ''
      body {
        color: red !important;
      }
    '';
  };

  search = {
    defaultSearchEngine = "Brave";
    removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
    searxUrl = "https://searx.be";
    searxQuery = "https://searx.be/search?q={searchTerms}&categories=general";
    addEngines = [
      {
        Name = "Etherscan";
        Description = "Checking balances";
        Alias = "!eth";
        Method = "GET";
        URLTemplate = "https://etherscan.io/search?f=0&q={searchTerms}";
      }
    ];
  };

  security = {
    sanitizeOnShutdown = false;
    sandbox = true;
    userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
  };

  misc = {
    drmFix = true;
    disableWebgl = false;
    startPageURL = "file://${builtins.readFile ./startpage.html}";
  };

  extensions.extraExtensions = {
    "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
  };

  bookmarks = [
    {
      Title = "Example";
      URL = "https://example.com";
      Favicon = "https://example.com/favicon.ico";
      Placement = "toolbar";
      Folder = "FolderName";
    }
  ];

}
```

## Credits <3

Thanks to the awesome people below:

- [hnhx](https://github.com/hnhx)
- [neoney](https://github.com/n3oney)
