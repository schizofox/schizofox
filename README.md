<p align="center">
    <img src="https://github.com/schizofox/assets/blob/main/logo/logo.png" alt="screenshot" width="200" align="center" />
</p>

<h1 align="center" style="font-size: 65px">
    Schizofox
</h1>

<div align="center">
    <p align="center">
        Firefox configuration wrapper for the Delusional and the
        Schizophrenic</br>
    </p>
    <!-- Repo Info -->
    <img alt="Stars" src="https://img.shields.io/github/stars/schizofox/schizofox">
    <img alt="Forks" src="https://img.shields.io/github/forks/schizofox/schizofox">
    <img alt="Issues" src="https://img.shields.io/github/issues/schizofox/schizofox">
    <img alt="Pull Requests" src="https://img.shields.io/github/issues-pr/schizofox/schizofox">
</div>

## About Schizofox

[Sioodmy's dotfiles]: https://github.com/sioodmy/dotfiles
[@NotAShelf]: https://github.com/notashelf
[Nyx]: https://github.com/notashelf/nyx

### Preface

Schizofox has started as an unnamed Firefox configuration as a part of
[Sioodmy's dotfiles] and was later adapted by [@NotAShelf] in [Nyx] for future
use.

As we came to notice it would not be feasible to maintain two separate
configurations, Schizofox has since been moved into its own standalone flake and
eventually an organization. Thus, this project is the result of combined efforts
of two people with special interest in security.

### What is Schizofox?

Schizofox is, simply put, a Firefox "distribution" (think Neovim distributions)
with hardened, preferable defaults and extensive customizability. In addition to
prioritizing privacy and security, Schizofox allows modifying its behaviour for
extended compatibility, should the user prefer that.

Compared to other browsers or browser configurations, Schizofox is quite
_schizoprenic_ but it is also designed for daily-driving, so some compromises
had to be made. Nevertheless, most options that affect privacy or security are
behind toggles and you can enable or disable, should you wish to do so.

Keep in mind that any _"super ultra privacy friendly Firefox configuration"_
will make you stick out, and contribute to fingerprinting; sadly there is no
escape from that, not with a regular browser. If you are really looking for
security, we would recommend that look into the Tor browser.

<!-- deno-fmt-ignore-start -->

> [!NOTE]
> Fun fact: clearing cookies is just a waste of time with cookie
> isolation enabled: just use temporary containers if you need to.

<!-- deno-fmt-ignore-end -->

## Notable Features <a name = "doc_features"></a>

[Nixpak]: https://github.com/nixpak/nixpak

- [x] Extensive & modular configuration
  - [x] Custom policy options
  - [x] Declarative extension installation with the provided [Home-Manager]
        module.
  - [x] Custom `userStyle` and `userChrome` configurations
- [x] Declarative theming. Schizofox allows for browser-wide theming with 3
      colors and a font, with DarkReader integration.
- [x] Optional [NixPak] wrapping sandboxing and additional security
- [x] Searx instance randomizer
- [ ] User agent randomizer
- [ ] Tor wrapper

## Installing Schizofox

[Home-Manager]: https://github.com/nix-community/home-manager

For the time being, Schizofox **only** supports [Home-Manager] installations.
This is because it is infinitely more tedious to try to write to ~/.mozilla
without Home-Manager, and because Firefox provides _no good way_ to set
policy/storage/userChrome/userContent paths.

### Using the Home-Manager module

Add Schizofox as a flake input:

```nix
# flake.nix
{
  inputs = {
    # ...
    schizofox.url = "github:schizofox/schizofox";
    # ...
  }
}
```

And then add `inputs.schizofox.homeManagerModules.default` to `imports` in a
Home-Manager configuration file. That's all, you can now use
`programs.schizofox.enable` to enable Schizofox. Refer to sample configuration
or the module options to learn more about how to modify Schizofox' behaviour.

### Contributing <a name="doc_contributing"></a>

Schizofox should still be considered beta software, although it is being daily
driven by many. Expect breaking changes, and make sure to submit an issue in
case anything breaks. If you know how to fix an existing issue, or would like to
implement new changes then feel free to create a pull request.

## Sample Configuration

<!-- deno-fmt-ignore-start -->

> [!WARNING]
> Sample configuration may be outdated at any given time. If you receive
> warnings about outdated configuration options, please refer to the module
> options for intended usage. Schizofox will attempt to remain
> backwards-compatible at all times, but this is not _always_ feasible.

<!-- deno-fmt-ignore-end -->

<details>
  <summary>Click to expand!</summary>

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
    sanitizeOnShutdown.enable = true;
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

</details>

## Frequently Asked Questions (FAQ)

**Q:** An user.js preference is greyed out, and overrides my own settings set in
`programs.schizofox.settings`!

**A:** This is usually the case when an _enterprise policy_ takes priority over
your preferences. If you do not set any enterprise policies yourself, open an
issue. We will handle it.

## 💛 Support Us <a name="doc_support_us"></a>

Schizofox is maintained by the people below. If it has helped you in any shape
or form, please consider supporting us to help us continue developing Schizofox.
Thank you in advance!

<div align="center">
    <div align="center" style="border: none;">
        <h3 align="center" style="font-size: 55px">
            Maintainers
        </h3>
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
        <h3 align="center" style="font-size: 55px">
            Organization
        </h3>
        <a href="https://liberapay.com/schizofox/donate">
            <img src="https://img.shields.io/liberapay/patrons/notashelf.svg?logo=liberapay?color=e5c890&labelColor=303446&style=for-the-badge">
        </a>
    </div>
</div>

### Contributors and Credits <a name="doc_contributors_credits"></a>

<div align="center">
    Schizofox has been made possible with the invaluable contributions of the people
    below. Please make sure to check them out, or support them <3
    <div align="center" style="border: none;">
        <table align="center" style="border-collapse: collapse; margin: 0 auto;">
            <!-- First Row -->
            <tr align="center">
                <!-- mrtnvgr -->
                <td align="center">
                    <a href="https://github.com/mrtnvgr" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/48406064?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center">mrtnvgr (Contributor)</h3>
                </td>
                <!-- Gerg -->
                <td align="center">
                    <a href="https://github.com/gerg-l" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/88247690?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center">gerg-l (Contributor) </h3>
                </td>
                <!-- Max Headroom -->
                <td align="center">
                    <a href="https://github.com/max-privatevoid" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/55053574?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center">Max Headroom (Contributor)</h3>
                </td>
            </tr>
            <!-- Second Row -->
            <tr align="center">
                <!-- louis-thevenet -->
                <td align="center">
                    <a href="https://github.com/louis-thevenet" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/55986107?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center">louis-thevenet (Contributor)</h3>
                </td>
                <!-- nyawox -->
                <td align="center">
                    <a href="https://github.com/nyawox" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/93813719?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center"> nyawox (Contributor)</h3>
                </td>
                <!-- Chomky -->
                <td align="center">
                    <a href="https://github.com/justchokingaround" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/44473782?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center"> Chomky (Contributor)</h3>
                </td>
            </tr>
            <!-- Third Row -->
            <tr align="center">
                <!-- Surfaceflinger -->
                <td align="center">
                    <a href="https://github.com/surfaceflinger" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/44725111?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center">Surfaceflinger (Contributor)</h3>
                </td>
                <!-- Diniamo -->
                <td align="center">
                    <a href="https://github.com/diniamo" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/55629891?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center">diniamo (Contributor)</h3>
                </td>
                <!-- eriedaberrie -->
                <td align="center">
                    <a href="https://github.com/eriedaberrie" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/64395218?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center">eriedaberria (Contributor)</h3>
                </td>
            </tr>
        </table>
    </div>
</div>

<div align="center">
    In addition, our special thanks go to the people below for their support.
    <div align="center" style="border: none;">
        <table align="center" style="border-collapse: collapse; margin: 0 auto;">
            <tr align="center">
                <!-- hnhx -->
                <td align="center">
                    <a href="https://github.com/hnhxr" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/49120638?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center">hnhx</h3>
                </td>
                <!-- neoney -->
                <td align="center">
                    <a href="https://github.com/n3oney" style="text-decoration: none;">
                        <img align="center" src='https://avatars.githubusercontent.com/u/30625554?s=55&v=4' width="55" height="55", style="border-radius: 50%;">
                    </a>
                    <h3 align="center">neoney</h3>
                </td>
            </tr>
        </table>
    </div>

</div>
