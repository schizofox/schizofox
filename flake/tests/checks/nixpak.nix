{
  pkgs,
  nixosModules,
  testers,
}:
testers.nixosTest {
  name = "schizofox-sandbox";

  meta.maintainers = with pkgs.lib.maintainers; [NotAShelf];

  nodes.machine = {
    imports = [
      ../profiles/test-setup.nix
      nixosModules.schizofox
    ];

    programs.schizofox = {
      enable = true;
      security.sandbox.enable = true;
      settings."browser.startup.homepage" = "about:preferences";
      settings."browser.startup.page" = 1;
    };
  };

  testScript = ''
    from datetime import timedelta

    machine.wait_for_x()
    machine.succeed("test -f /root/.Xauthority")

    with subtest("Sandboxed Firefox opens Settings without an Autoconfig error dialog"):
        machine.succeed("XAUTHORITY=/root/.Xauthority XDG_RUNTIME_DIR=/run/user/0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/0/bus schizofox >&2 &")
        machine.wait_for_window("Settings", timeout=timedelta(seconds=60))

  '';
}
