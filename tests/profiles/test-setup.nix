{
  pkgs,
  lib,
  ...
}: {
  # he's a thicc boi
  virtualisation = {
    cores = 4;
    memorySize = 4096;
    qemu.options = ["-vga none -enable-kvm -device virtio-gpu-pci,xres=720,yres=1440"];
  };

  users.users.test = {
    isNormalUser = true;
    password = "";
  };

  home-manager.sharedModules = [
    {home.stateVersion = "23.05";}
  ];

  environment.systemPackages = [pkgs.xdotool];

  # Create a virtual sound device, with mixing
  # and all, for recording audio.
  boot.kernelModules = ["snd-aloop"];
  sound.enable = true;
  sound.extraConfig = ''
    pcm.!default {
      type plug
      slave.pcm pcm.dmixer
    }
    pcm.dmixer {
      type dmix
      ipc_key 1
      slave {
        pcm "hw:Loopback,0,0"
        rate 48000
        periods 128
        period_time 0
        period_size 1024
        buffer_size 8192
      }
    }
    pcm.recorder {
      type hw
      card "Loopback"
      device 1
      subdevice 0
    }
  '';

  systemd.services.audio-recorder = {
    description = "Record test audio to /tmp/record.wav";
    script = "${pkgs.alsa-utils}/bin/arecord -D recorder -f S16_LE -r48000 /tmp/record.wav";
  };

  services.xserver = {
    enable = true;

    windowManager.icewm.enable = true;
    displayManager = {
      defaultSession = lib.mkDefault "none+icewm";
      autoLogin = {
        enable = true;
        user = "test";
      };
    };
  };
}
