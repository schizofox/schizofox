{
  lib,
  pkgs,
  ...
}: {
  virtualisation = {
    cores = 4;
    memorySize = 4096;
  };

  services = {
    xserver = {
      # Minimal X11 session as root, based on what the upstream nixpkgs
      # Firefox tests do.
      # See:
      #  nixos/tests/common/x11.nix,
      #   nixos/tests/common/auto.nix.
      enable = true;
      displayManager.lightdm.enable = true;
      windowManager.icewm.enable = true;
    };

    displayManager.autoLogin = {
      enable = true;
      user = "root";
    };

    displayManager.defaultSession = lib.mkDefault "none+icewm";
  };

  # lightdm by default doesn't allow auto login for root, which is
  # required by some nixos tests; override it here.
  security.pam.services.lightdm-autologin.text = lib.mkForce ''
    auth     requisite pam_nologin.so
    auth     required  pam_succeed_if.so quiet
    auth     required  pam_permit.so

    account  include   lightdm
    password include   lightdm
    session  include   lightdm
  '';

  environment = {
    etc = {
      # Help with OCR
      "icewm/theme".text = ''
        Theme="gtk2/default.theme"
      '';

      # Remove task bar to avoid non-determinism
      "icewm/preferences".text = ''
        ShowTaskBar=0
      '';
    };

    systemPackages = [pkgs.xdotool];
  };
}
