{
  pkgs,
  nixosModules,
  testers,
}:
testers.nixosTest {
  name = "schizofox-sandbox";

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
      security.sandbox.enable = true;
    };
  };

  testScript = ''
    machine.wait_for_x()

    with subtest("Sandboxed Schizofox launches"):
        machine.succeed("schizofox about:preferences >&2 &")
        machine.wait_for_window("Firefox")
        machine.sleep(30)

    with subtest("Sandboxed Schizofox carries the hardened policies"):
        pkg = machine.succeed("dirname $(dirname $(readlink -f $(command -v schizofox)))").strip()
        machine.succeed(f"grep -q 'DisableTelemetry' {pkg}/lib/firefox/distribution/policies.json")
        machine.succeed(f"grep -q 'privacy.resistFingerprinting' {pkg}/lib/firefox/mozilla.cfg")
  '';
}
