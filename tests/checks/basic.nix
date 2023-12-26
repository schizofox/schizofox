{
  nixosTest,
  homeManagerModules,
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
nixosTest {
  name = "basic";

  nodes.machine = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      ../profiles/test-setup.nix
    ];

    home-manager = {
      sharedModules = [homeManagerModules.schizofox];
      users.test = {
        programs.schizofox.enable = true;
      };
    };
  };

  testScript = let
    exe = lib.getExe package; # TODO: how do we obtain the package?
  in ''
    from contextlib import contextmanager


    @contextmanager
    def record_audio(machine: Machine):
        """
        Perform actions while recording the
        machine audio output.
        """
        machine.systemctl("start audio-recorder")
        yield
        machine.systemctl("stop audio-recorder")


    def wait_for_sound(machine: Machine):
        """
        Wait until any sound has been emitted.
        """
        machine.wait_for_file("/tmp/record.wav")
        while True:
            # Get at most 2M of the recording
            machine.execute("tail -c 2M /tmp/record.wav > /tmp/last")
            # Get the exact size
            size = int(machine.succeed("stat -c '%s' /tmp/last").strip())
            # Compare it against /dev/zero using `cmp` (skipping 50B of WAVE header).
            # If some non-NULL bytes are found it returns 1.
            status, output = machine.execute(
                f"cmp -i 50 -n {size - 50} /tmp/last /dev/zero 2>&1"
            )
            if status == 1:
                break
            machine.sleep(2)


    machine.wait_for_x()

    with subtest("Wait until Firefox has finished loading the Valgrind docs page"):
        machine.execute(
            "xterm -e '${exe} file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html' >&2 &"
        )
        machine.wait_for_window("Valgrind")
        machine.sleep(40)

    with subtest("Check whether Firefox can play sound"):
        with record_audio(machine):
            machine.succeed(
                "${exe} file://${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/phone-incoming-call.oga >&2 &"
            )
            wait_for_sound(machine)
        machine.copy_from_vm("/tmp/record.wav")

    with subtest("Close sound test tab"):
        machine.execute("xdotool key ctrl+w")

    with subtest("Close default browser prompt"):
        machine.execute("xdotool key space")

    with subtest("Wait until Firefox draws the developer tool panel"):
        machine.sleep(10)
        machine.succeed("xwininfo -root -tree | grep Valgrind")
        machine.screenshot("screen")
  '';
}
