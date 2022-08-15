{ ... }:
{
  boot = {
    loader = {
      #systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        version=2;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        };
    };
  };
}
