# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./packages.nix
      ./services.nix
      ./sddm.nix
      ./boot.nix
#      {
#        inherit ytmp;
#      }
    ];
  # Use the systemd-boot EFI boot loader.

  # systemd.services.blueman = {
  #	script = ''
  #	  systemctl --machine=<user>@.host --user start blueman-applet
  #	'';
  #	wantedBy = [ "multi-user.target" ];
  #  };
  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides =  pkgs: rec{
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  

  networking = {
    hostName = "fg002"; # Define your hostname.
    #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    useDHCP = false;
    interfaces.eno1.useDHCP = true;



    networkmanager.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
 


  virtualisation.libvirtd.enable = true;
  programs = {
    dconf.enable = true;
    nm-applet.enable = true;
    light.enable = true;
  };  

  users = {
    users.ahmed = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
    };
    defaultUserShell = pkgs.fish;
  };
  time.timeZone = "Europe/Istanbul";


  environment.variables = {
		#BROWSER = "google-chrome";
		TERMINAL = "kitty";
		EDITOR = "nvim";
  };


  

  fonts.fonts = with pkgs; [
	(nerdfonts.override { fonts = [ "FiraCode" ]; })
    font-awesome_5
     
  ];

  system.stateVersion = "21.11"; 

}

