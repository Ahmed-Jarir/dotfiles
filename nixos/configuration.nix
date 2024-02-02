{ config, pkgs, lib, ... }:

{
  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  imports =
  [
      ./boot.nix
      ./hardwareConfiguration.nix
      ./packages.nix
      ./services.nix
  ];

  # nixpkgs.overlays = [
  #   (final: prev: {
  #     avr-sim = pkgs.callPackage ./avr-sim.nix { };
  #   })
  # ];

  networking = {
    hostName = "nixos";
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Istanbul";

  sound.enable = true;
   
  virtualisation =  {

    libvirtd.enable = true;

  };

  programs = {

    dconf.enable = true;
    nm-applet.enable = true;
    light.enable = true;
    fish.enable = true;

  };  
  users = {
    users.ahmed = {
      isNormalUser = true;
      description = "ahmed";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
      shell = pkgs.fish;
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides =  pkgs: rec{
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };
   
  fonts.packages = with pkgs; [

	(nerdfonts.override { fonts = [ "FiraCode" ]; })
    font-awesome_5

  ];

  system.stateVersion = "22.05";
}
