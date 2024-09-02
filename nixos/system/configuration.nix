{ config, pkgs, ... }:

{

  imports =
    [
      ./boot.nix
      ./hardware-configuration.nix
      ./packages.nix
      ./services.nix
    ];

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    package = pkgs.nixVersions.latest;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking = {
    hostName = "nixos";
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Asia/Jerusalem";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  security.rtkit.enable = true;

  virtualisation =  {
    libvirtd.enable = true;
    virtualbox.host.enable = true;
  };
  programs = {
    dconf.enable = true;
    nm-applet.enable = true;
    light.enable = true;
    fish.enable = true;
  };  

  users.users.ahmed = {
    isNormalUser = true;
    description = "ahmed";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.fish;
  };

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


  system.stateVersion = "24.05";

}
