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

### Notable Features <a name = "doc_features"></a>

[Nixpak]: https://github.com/nixpak/nixpak

- [x] Extensive & modular configuration
  - [x] Custom policy options
  - [x] Declarative extension installation with the provided [Home-Manager]
        module.
  - [x] Custom `userStyle` and `userChrome` configurations
  - [x] Standalone and wrappable packaging
    - [x] Works on Hjem, NixOS and Home-Manager
- [x] Declarative theming. Schizofox allows for browser-wide theming with 3
      colors and a font, with DarkReader integration.
- [x] Optional [NixPak] wrapping sandboxing and additional security
- [x] Searx instance randomizer

For future consideration:

- [ ] User agent randomizer (as an extension?)
- [ ] Tor wrapper (maybe just use the Tor browser...)

## Installing Schizofox

Schizofox provides two _module_ interfaces. Those are the NixOS and Home-Manager
modules, constructed directly through the underlying wrapper interface. The
modules supply Schizofox's default policies and preferences; direct wrapper
callers must supply their own.

> [!TIP] Hjem users are encouraged to use the `schizofox-unwrapped` package, and
> wrap it manually as described in [Using-the-wrapper-without-a-module]. Same
> mechanism can be used by NixOS and Home-Manager users as well.

To get started, add Schizofox as a flake input:

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

### Using the NixOS module

In a NixOS configuration that receives `inputs` through
`specialArgs = {inherit inputs;}`:

```nix
{inputs, pkgs, ...}: {
  imports = [inputs.schizofox.nixosModules.default];
  nixpkgs.overlays = [inputs.schizofox.overlays.default];

  programs.schizofox = {
    enable = true;
    package = pkgs.firefox-esr-140-unwrapped;
    settings."browser.startup.homepage" = "https://example.org";
  };
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

The module installs the configured wrapper where preferences and stylesheets
come from the wrapper's Autoconfig. Existing Firefox profiles remain entirely
yours. Do note that the `package` field MUST be an unwrapped Firefox ESR
package. Schizofox will refuse to support non-ESR Firefox as well as wrapped
packages.

The modules use the Schizofox package overlay internally. For `pkgs.mkSchizofox`
and the extension packages to be available throughout your configuration, add
`inputs.schizofox.overlays.default` to your nixpkgs overlays. For standalone
Home Manager, set `nixpkgs.overlays`; when Home Manager uses NixOS's global
`pkgs`, set the overlay on NixOS instead.

The module installs Schizofox system-wide. Set
`programs.schizofox.search.searxRandomizer.enable = true` to install its user
service; its default search configuration does not require the service.

### Using the wrapper without a module

Hjem users or any user planning to install Schizofox on non-NixOS using, say,
`nix profile` can create a package and construct a wrapper from the overlay. To
use this mechanism, install the overlay and construct a wrapper in a NixOS
configuration with `inputs` passed through `specialArgs`:

```nix
{inputs, pkgs, ...}: let
  # XXX: this assumes `pkgs` has been constructed from the overlay. You'll need
  # to consume the overlay, or, call the mkSchizofox package yourself.
  schizofox = pkgs.mkSchizofox {
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
  nixpkgs.overlays = [inputs.schizofox.overlays.default]; # <- this is one way of consuming the overlay

  # You can add the wrapped package to environment.systemPackages or
  # alternatives like users.users.<name>.packages.
  environment.systemPackages = [schizofox.wrapped];
}
```

In this example:

- `policies` replaces the module's policy defaults. Setting only
  `DisableTelemetry` is **not equivalent to the hardened module configuration**.
- `preferences` sets Autoconfig defaults. `chrome.userChrome` is scoped to
  `chrome://` browser documents; `chrome.userContent` styles content documents.
  Both are loaded from the store for every profile on every launch.
- `wrapped` is the Firefox wrapper. `package` is the same wrapper unless both
  `nixpakLib` is provided and `sandbox.enable` is true. The wrapper also returns
  `searx-randomizer-unit` for callers installing the search service.
- `wrapperArgs` accepts additional wrapper arguments such as
  `nativeMessagingHosts`, `pkcs11Modules`, `extraPrefsFiles`, and
  `extraPolicies`. Explicit `extraPolicies` keys override Schizofox defaults.
  Additional `extraPrefsFiles` follow Schizofox's generated Autoconfig file;
  only use trusted files because Autoconfig executes privileged JavaScript.

You may set `prefName = "lockPref"` to lock all generated preferences instead of
providing overridable defaults. This is also available as a module option.

Note that on upgrade from an older Home Manager deployment, its managed
`profiles.ini`, `schizo.default/user.js`, and `chrome/userChrome.css` /
`chrome/userContent.css` links are **no longer installed**. Back up your profile
before switching. Existing profile data is not deleted, but without the old
`profiles.ini`, Firefox may create a new default profile; select
`schizo.default` in `about:profiles` if you want to keep using it. Old values
saved in that profile's `prefs.js` can still override Autoconfig defaults; reset
them in `about:config` to use the new defaults.

> [!TIP] For a disposable trial, select a new profile explicitly instead of
> changing your normal Firefox profile (set `security.sandbox.enable = false`
> first):
>
> ```sh
> # Easy way to test
> $ profile="$(mktemp -d)"
> $ schizofox --no-remote --profile "$profile" about:preferences
> $ rm -rf -- "$profile" # only the directory just created by mktemp
> ```

### Optional Adifox wrapper

[Adifox]: https://github.com/NotAShelf/adifox

[Adifox] is an alternative Firefox wrapper that has been created as a side
experiment. Schizofox does not use it by default, but lets you _opt-in_ to using
Adifox as the wrapper.

You can supply an adapter through `programs.schizofox.wrapFirefox` (or
`wrapFirefox` when calling `pkgs.mkSchizofox` directly). In a consumer flake,
add `adifox.url = "github:NotAShelf/adifox"; adifox.flake = false;` and
`lladios.url = "github:llakala/lladios";`, then pin both in your lockfile:

```nix
{inputs, pkgs, ...}: let
  lladios = inputs.lladios.adios;
  tree = lladios {
    name = "root";
    modules = {
      nixpkgs = {
        name = "nixpkgs";
        options = {
          pkgs.type = lladios.types.attrs;
          lib = {
            type = lladios.types.attrs;
            defaultFunc = {options}: options.pkgs.lib;
          };
        };
      };
      wrapAdifox = import (inputs.adifox + "/wrapAdifox.nix") lladios;
    };
  } {options."/nixpkgs".pkgs = pkgs;};
in {
  imports = [inputs.schizofox.nixosModules.default];
  programs.schizofox = {
    enable = true;
    wrapFirefox = browser: args:
      tree.modules.wrapAdifox ({package = browser;} // args);
  };
}
```

Use `homeManagerModules.default` instead when configuring Home Manager. The
`package` option remains the **unwrapped** ESR browser; Adifox replaces
`wrapFirefox`, rather than wrapping a wrapper. `nixExtensions` should not be
combined with Schizofox's extension policies.

## Contributing <a name="doc_contributing"></a>

Schizofox should still be considered beta software, although it is being daily
driven by many. Expect breaking changes, and make sure to submit an issue in
case anything breaks. If you know how to fix an existing issue, or would like to
implement new changes then feel free to create a pull request.

## Frequently Asked Questions (FAQ)

**Q:** A preference is greyed out, or my `programs.schizofox.settings` value
does not appear in an existing profile.

**A:** Enterprise policies can lock a preference. Otherwise, `pref` sets the
default branch; a saved user value in the profile's `prefs.js` overrides it.
Reset the preference in `about:config` to restore the wrapper default.

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
