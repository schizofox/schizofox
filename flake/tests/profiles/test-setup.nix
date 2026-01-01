{config, ...}: {
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
    {home.stateVersion = config.system.stateVersion;}
  ];

  services = {
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "test";
      };
    };

    desktopManager.gnome.enable = true;
  };
}
