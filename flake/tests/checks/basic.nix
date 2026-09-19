{
  pkgs,
  nixosModules,
  testers,
}:
testers.nixosTest {
  name = "schizofox-basic";

  meta.maintainers = with pkgs.lib.maintainers; [
    sioodmy
    NotAShelf
  ];

  nodes.machine = {
    imports = [
      ../profiles/test-setup.nix
      nixosModules.schizofox
    ];

    programs.schizofox = {
      enable = true;
      security.resistFingerprinting.enable = true;
      search.searxRandomizer.enable = true;
    };
  };

  testScript = ''
    machine.wait_for_x()

    with subtest("Schizofox launches"):
        machine.succeed("schizofox about:preferences >&2 &")
        machine.wait_for_window("Firefox")
        machine.sleep(30)

    with subtest("Privacy settings are applied to the wrapper"):
        pkg = machine.succeed("dirname $(dirname $(readlink -f $(command -v schizofox)))").strip()
        machine.succeed(f"test -e {pkg}/lib/firefox/distribution/policies.json")
        machine.succeed(f"grep -q 'DisableTelemetry' {pkg}/lib/firefox/distribution/policies.json")
        machine.succeed(f"grep -q 'DisableFirefoxStudies' {pkg}/lib/firefox/distribution/policies.json")
        machine.succeed(f"grep -q 'privacy.resistFingerprinting' {pkg}/lib/firefox/mozilla.cfg")
        machine.succeed(f"grep -q 'block_mozAddonManager' {pkg}/lib/firefox/mozilla.cfg")

    with subtest("Searx randomizer user unit exists"):
        machine.wait_until_succeeds(
            "XDG_RUNTIME_DIR=/run/user/0 systemctl --user cat searx-randomizer.service"
        )

    with subtest("Schizofox displays the preferences window"):
        machine.execute("xdotool key ctrl+l")
        machine.sleep(5)
        machine.screenshot("schizofox")
  '';
}
