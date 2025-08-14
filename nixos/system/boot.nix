{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
      };
    };
    plymouth = {
      enable = true;
      themePackages = [ pkgs.plymouth-vortex-ubuntu-theme ];
      theme = "vortex-ubuntu";
      # theme = "plymouth-vortex-ubuntu-theme";
    };
  };
}
