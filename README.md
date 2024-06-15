<p align="center">
    <img src="https://github.com/schizofox/assets/blob/main/logo/logo.png" alt="screenshot" width="200" align="center" />
</p>

<h1 align="center" style="font-size: 65px">
    Schizofox
</h1>

<div align="center">
    <p align = "center">
        Firefox configuration wrapper for the Delusional and the
        Schizoprenic
    </p>
    <!-- Repo Info -->
    <img alt="Stars" src="https://img.shields.io/github/stars/schizofox/schizofox">
    <img alt="Forks" src="https://img.shields.io/github/forks/schizofox/schizofox">
    <img alt="Issues" src="https://img.shields.io/github/issues/schizofox/schizofox">
    <img alt="Pull Requests" src="https://img.shields.io/github/issues-pr/schizofox/schizofox">
    <!-- Author Info -->
    <div align="center" style="border: none;">
        <table align="center" style="border-collapse: collapse; margin: 0 auto;">
            <tr align="center">
                <!-- NotAShelf -->
                <td align="center">
                    <h3 align="center">NotAShelf (Maintainer)</h3>
                    <a href="https://ko-fi.com/notashelf" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/62766066?s=55&v=4' width="55" height="55">
                        <img align="center" src='https://ko-fi.com/img/githubbutton_sm.svg'>
                    </a>
                </td>
                <!-- Sioodmy -->
                <td align="center">
                    <h3 align="center">Sioodmy (Maintainer)</h3>
                    <a href="https://ko-fi.com/sioodmy" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/81568712?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                        <img align="center" src='https://ko-fi.com/img/githubbutton_sm.svg'>
                    </a>
                </td>
            </tr>
        </table>
    </div>
</div>

## About Schizofox

Schizofox started as a part of
[Sioodmy's dotfiles](https://github.com/sioodmy/dotfiles) and was adapted by
[NotAShelf](https://github.com/notashelf/nyx) for future use. As such, it has
been moved into its own standalone flake and eventually an organization.

Compared to other browsers/configurations, I would say it's pretty
_schizophrenic_, but it is also daily driveable so some compromises were made.
Keep in mind that any "super ultra privacy friendly firefox config" will make
you stick out and won't protect you from fingerprinting; sadly there is no
escape from that. If you are really looking for security, look into the Tor
browser.

Fun fact: clearing cookies is just a waste of time with cookie isolation enabled
(just use temporary containers if you need to)

### Notable Features

- Declarative theming. Just specify 3 colors and your font of choice and nix
  will do the rest (userChrome.css and darkreader config)
- Declarative extension installation with the home-manager module
- NixPak wrapped package
- Extensive & modular configuration

### Contributing

Schizofox is still beta software, and breaking changes are to be expected.

Make sure to submit an issue in case anything breaks, or make a PR if you know
how to fix said issue.

## 💛 Donate

If you would like to support us, you may use Liberapay to do so:

<a href="https://liberapay.com/schizofox/donate"><img src="https://img.shields.io/liberapay/patrons/notashelf.svg?logo=liberapay?color=e5c890&labelColor=303446&style=for-the-badge"></a>

## Configuration

```nix
imports = [ inputs.schizofox.homeManagerModule ];
programs.schizofox = {
  enable = true;

  theme = {
    colors = {
      background-darker = "181825";
      background = "1e1e2e";
      foreground = "cdd6f4";
    };

    font = "Lexend";

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
    contextMenu.enable = true;
  };

  extensions = {
    simplefox.enable = true;
    darkreader.enable = true;

    extraExtensions = {
      "webextension@metamask.io".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ether-metamask/latest.xpi";
    };
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
