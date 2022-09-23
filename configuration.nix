{ config, pkgs, lib, ytmp, ... }:

{

  nix = {

    autoOptimiseStore = true;
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

  };

  imports =
    [
      ./hardware-configuration.nix
      ./packages.nix
      ./services.nix
      ./sddm.nix
      ./boot.nix
    ];

  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides =  pkgs: rec{
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  networking = {

    hostName = "fg002";
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    networkmanager.enable = true;

  };

  virtualisation =  {

    libvirtd.enable = true;
    docker.enable = true;

  };

  programs = {

    dconf.enable = true;
    nm-applet.enable = true;
    light.enable = true;

  };  

  users = {
    users.ahmed = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
    };
    defaultUserShell = pkgs.fish;
  };
  time.timeZone = "Europe/Istanbul";


  environment.variables = {

		TERMINAL = "kitty";
		EDITOR = "nvim";

  };

  fonts.fonts = with pkgs; [

	(nerdfonts.override { fonts = [ "FiraCode" ]; })
    font-awesome_5

  ];

  system.stateVersion = "21.11"; 

}

