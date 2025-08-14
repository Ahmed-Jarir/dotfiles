{ pkgs, ... }:
{
  imports = [
    ../../sddm/sddm.nix
  ];
  services = {

    libinput = {
      enable = true;
      touchpad = {
      naturalScrolling = true;
        middleEmulation = true;
        tapping = true;
      };
    };

    upower = {
      enable = true;
      usePercentageForPolicy = true;
      percentageLow = 40;
      percentageCritical = 10;
      percentageAction = 20;
      criticalPowerAction = "Hibernate";
    };
    printing.enable = true;
    blueman.enable = true;
    dbus.packages = with pkgs; [ blueman ];

    physlock = {
      enable = true;
      allowAnyUser = true;
    };
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      # displayManager.gdm.enable = true;

      videoDrivers = [ "nvidia" ];
      windowManager ={
        qtile.enable = true;
      };
      xkb = {
        options = "ctrl:nocaps";
        layout = "us,ara";
      };

      xkbOptions = "grp:ctrl_alt";
    };
  }; 
  console.useXkbConfig = true;
}
