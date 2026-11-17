{
  pkgs,
  nixosModules,
  overlays,
  testers,
}:
testers.nixosTest {
  name = "schizofox-basic";

  meta.maintainers = with pkgs.lib.maintainers; [NotAShelf];

  nodes.machine = {
    nixpkgs.overlays = [overlays.default];
    imports = [
      ../profiles/test-setup.nix
      nixosModules.schizofox
    ];

    programs.schizofox = {
      enable = true;
      security.resistFingerprinting.enable = true;
      security.sandbox.enable = false;
      search.searxRandomizer.enable = true;
      settings."browser.startup.homepage" = "about:preferences#privacy";
      settings."browser.startup.page" = 1;
      theme.colors = {
        background = "332244";
        background-darker = "241c32";
        foreground = "e0cfee";
      };
      theme.extraUserChrome = ''
        .urlbar-background { background: #00ff00 !important; }
      '';
      theme.extraUserContent = ''
        @-moz-document url("about:blank") {
          html { background: #ff0000 !important; }
        }
      '';
    };
  };

  testScript = ''
    import subprocess
    from datetime import timedelta

    with subtest("Wrapper uses the selected unwrapped Firefox"):
        assert "${pkgs.firefox-esr-153-unwrapped.version}" in machine.succeed("schizofox --version")

    machine.wait_for_x()
    with subtest("Firefox opens configured homepage without an Autoconfig error"):
        machine.succeed("schizofox >&2 &")
        machine.wait_for_window("Settings", timeout=timedelta(seconds=60))
        machine.succeed("xdotool search --onlyvisible --name 'Settings'")

    with subtest("Searx randomizer user unit exists"):
        machine.wait_until_succeeds(
            "XDG_RUNTIME_DIR=/run/user/0 systemctl --user cat searx-randomizer.service",
            timeout=timedelta(seconds=60),
        )

    with subtest("Theme colors apply to the settings page"):
        machine.screenshot("schizofox")
        ppm = subprocess.check_output(["pngtopnm", str(machine.out_dir / "schizofox.png")])
        header, pixels = ppm.split(b"\n255\n", 1)
        assert header.startswith(b"P6\n"), header[:80]
        geometry = {
            key: int(value)
            for key, value in (
                line.split("=")
                for line in machine.succeed(
                    "xdotool getwindowgeometry --shell "
                    "$(xdotool search --onlyvisible --name '^Settings' | head -1)"
                ).split()
            )
        }
        area = geometry["WIDTH"] * geometry["HEIGHT"]
        green_pixels = sum(
            r < 32 and g > 230 and b < 32
            for r, g, b in zip(pixels[::3], pixels[1::3], pixels[2::3])
        )
        assert green_pixels > area // 300, green_pixels
        settings_pixels = sum(
            (r, g, b) == (0x24, 0x1c, 0x32)
            for r, g, b in zip(pixels[::3], pixels[1::3], pixels[2::3])
        )
        assert settings_pixels > area // 4, settings_pixels
        toolbar_pixels = sum(
            (r, g, b) == (0x33, 0x22, 0x44)
            for r, g, b in zip(pixels[::3], pixels[1::3], pixels[2::3])
        )
        assert toolbar_pixels > area // 300, toolbar_pixels

    with subtest("Custom CSS applies to an unmodified Firefox profile"):
        machine.succeed("xdotool key ctrl+l")
        machine.succeed("xdotool type 'about:blank'")
        machine.succeed("xdotool key Return")
        machine.wait_for_window("^Mozilla Firefox$", timeout=timedelta(seconds=60))
        machine.screenshot("schizofox-styles")
        ppm = subprocess.check_output(
            ["pngtopnm", str(machine.out_dir / "schizofox-styles.png")]
        )
        header, pixels = ppm.split(b"\n255\n", 1)
        assert header.startswith(b"P6\n"), header[:80]
        red_pixels = sum(
            r > 230 and g < 32 and b < 32
            for r, g, b in zip(pixels[::3], pixels[1::3], pixels[2::3])
        )
        assert red_pixels > len(pixels) // 30, red_pixels
  '';
}
