<!--markdownlint-disable MD033 MD041-->

<p align="center">
    <img
        src="https://github.com/schizofox/assets/blob/main/logo/logo.png"
        alt="screenshot"
        width="200"
        align="center"
    />
</p>
<h1 align="center" style="font-size: 65px">Schizofox</h1>
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

Schizofox started as an unnamed Firefox configuration, living inside
[Sioodmy's dotfiles] and was later adapted by [@NotAShelf] in [Nyx] for future
use. As the two maintainers come to notice that it is not really _feasible_ to
maintain two separate Firefox configurations while borrowing from
one-or-another, Schizofox has been created as a standalone Nix flake, and was
later made into its own organization. Thus, this project is the result of
combined efforts of two people with special interest in security.

### What is Schizofox?

Schizofox is, simply put, a Firefox "distribution" (think Neovim distributions)
with hardened, preferable defaults and extensive customizability _without_
patching Firefox's source code. It takes the base ESR Firefox build, and wraps
it with reasonably safe defaults to prioritize private and secure browsing. In
addition, Schizofox offers a declarative interface for you to extend and modify
the defaults as you see fit.

Compared to most mainstream browsers, Schizofox is quite _schizoprenic_ but it
is also designed for daily-driving, so some compromises had to be made. That is,
with the necessary toggles to either opt in to or out of certain features. Which
is to say most options that affect privacy or security are behind toggles and
you can enable or disable, should you wish to do so.

Keep in mind that any _"super ultra privacy friendly Firefox configuration"_
will make you stick out, and contribute to fingerprinting; sadly there is no
escape from that; not with a regular browser. If you are really looking for
security, we would recommend that look into the Tor browser.

<!-- deno-fmt-ignore-start -->

> [!NOTE]
> Fun fact: clearing cookies is just a waste of time with cookie
> isolation enabled: just use temporary containers if you need to.

<!-- deno-fmt-ignore-end -->

[Arkenfox]: https://github.com/arkenfox/user.js
[LibreWolf]: https://codeberg.org/librewolf/source/raw/branch/main/settings/librewolf.cfg
[Mullvad Browser]: https://mullvad.net/en/browser
[Tor Browser]: https://www.torproject.org/download/

This project learns from hardening work published by [Arkenfox], [LibreWolf],
[Mullvad Browser], and the [Tor Browser]. Those projects have different
products, threat models, release processes, and compatibility requirements.
Their settings are research inputs, not a list to copy.

Schizofox is **not** Tor Browser or Mullvad Browser. It does not provide Tor
routing, configure a Tor proxy, enable First-Party Isolation, carry their
patches, or make an anonymity-set claim. In particular, a stock Firefox profile
with selected hardening preferences is not interchangeable with a browser that
is designed, built, and released to make its users look alike. Use Tor Browser
when its network and anonymity properties are required.

In the end Schizofox configures **stock Firefox ESR**. It is a desktop Firefox
configuration, not an _actual_ browser distribution. The baseline is
intentionally built for desktop use. We use Firefox's Enhanced Tracking
Protection (ETP) and Fingerprinting Protection (FPP), while the broader Resist
Fingerprinting (RFP) mode is an explicit opt-in.

### Hardening

See the [Firefox hardening model](docs/hardening.md) for Schizofox's
stock-Firefox ESR scope, public controls, and source audit.

### Notable Features <a name = "doc_features"></a>

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

Schizofox can be installed through the Home Manager or NixOS module, or
constructed directly as a Firefox wrapper. The modules supply Schizofox's
default policies and preferences; direct wrapper callers must supply their own.

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

### Using the Home-Manager module

[Home-Manager]: https://github.com/nix-community/home-manager

In a Home Manager configuration that receives `inputs` through
`extraSpecialArgs = {inherit inputs;}`:

```nix
{inputs, pkgs, ...}: {
  imports = [inputs.schizofox.homeManagerModules.default];

  programs.schizofox = {
    enable = true;
    package = pkgs.firefox-esr-140-unwrapped;
    settings."browser.startup.homepage" = "https://example.org";
    security.sandbox.enable = true;
  };
}
```

The module installs the configured package and manages its Firefox profile
files. `security.sandbox.enable` uses NixPak; omit it to use the unsandboxed
wrapper. `package` must be an unwrapped Firefox ESR package.

### Using the NixOS module

In a NixOS configuration that receives `inputs` through
`specialArgs = {inherit inputs;}`:

```nix
{inputs, pkgs, ...}: {
  imports = [inputs.schizofox.nixosModules.default];

  programs.schizofox = {
    enable = true;
    package = pkgs.firefox-esr-140-unwrapped;
    settings."browser.startup.homepage" = "https://example.org";
  };
}
```

The module installs Schizofox system-wide. Set
`programs.schizofox.search.searxRandomizer.enable = true` to install its user
service; its default search configuration does not require the service.

### Using the wrapper without a module

`lib.mkSchizofox` accepts final package inputs, **not** `programs.schizofox`
module options. This example installs a directly constructed wrapper in a NixOS
configuration with `inputs` passed through `specialArgs`:

```nix
{inputs, pkgs, ...}: let
  schizofox = (pkgs.callPackage inputs.schizofox.lib.mkSchizofox {}) {
    firefox-unwrapped = pkgs.firefox-esr-140-unwrapped;
    preferences = {"browser.startup.homepage" = "about:blank";};
    searchService.instances = [];
    wrapWithProxychains = false;
    chrome = {
      userChrome = "";
      userContent = "";
    };

    policies = {DisableTelemetry = true;};
    sandbox = {
      enable = false;
      extraBinds = [];
      allowFontPaths = false;
      customMozillaFolder = {
        enable = false;
        path = "";
      };
    };
  };
in {
  environment.systemPackages = [schizofox.wrapped];
}
```

`policies` replaces the module's policy defaults; the example sets only
`DisableTelemetry`, so it is **not equivalent to the hardened module
configuration**. `preferences` supplies `user.js` entries and `chrome` supplies
CSS strings. `wrapped` is the Firefox wrapper. `package` is the same wrapper
unless both `nixpakLib` is provided and `sandbox.enable` is true. Direct callers
must install `files` and `searx-randomizer-unit` themselves if they need Home
Manager-style profile files or the search service.

## Contributing <a name="doc_contributing"></a>

Schizofox should still be considered beta software, although it is being daily
driven by many. Expect breaking changes, and make sure to submit an issue in
case anything breaks. If you know how to fix an existing issue, or would like to
implement new changes then feel free to create a pull request.

## Frequently Asked Questions (FAQ)

**Q:** An `user.js` preference is greyed out, and overrides my own settings set
in `programs.schizofox.settings`!

**A:** This is usually the case when an _enterprise policy_ takes priority over
your preferences. If you do not set any enterprise policies yourself, open an
issue. We will handle it.

**Q:** How do I customize UI declaratively?

**A:** Firefox allows you to configure UI (toolsbars, not themes) via
`browser.uiCustomization.state` in `about:config`. This corresponds to
`programs.schizofox.settings."browser.uiCustomization.state" = builtins.toJSON {}`
in your Schizofox module.

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

### Source selection

- [Mozilla Firefox Administrator Reference](https://firefox-admin-docs.mozilla.org/)
  for deployment policies and their support status.
- [Arkenfox's upstream `user.js`](https://raw.githubusercontent.com/arkenfox/user.js/master/user.js)
  as a desktop Firefox hardening reference.
- [LibreWolf's upstream settings file](https://codeberg.org/librewolf/source/raw/branch/main/settings/librewolf.cfg)
  documents the project's chosen settings, not a portable contract for stock
  Firefox but considered nevertheless
