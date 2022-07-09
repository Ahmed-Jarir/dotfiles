# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

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
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  # systemd.services.blueman = {
  #	script = ''
  #	  systemctl --machine=<user>@.host --user start blueman-applet
  #	'';
  #	wantedBy = [ "multi-user.target" ];
  #  };
  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides =  pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };
  hardware = {
    #opengl.driSupport = true;
    firmware = [ pkgs.rtw89-firmware ];

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        #rocm-opencl-icd
        #rocm-opencl-runtime
        #amdvlk
        vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libvdpau-va-gl
      ];
    };
    nvidia.prime = {
      offload.enable = true;
  
      amdgpuBusId = "PCI:5:0:0";
  
      nvidiaBusId = "PCI:1:0:0";
    };
    pulseaudio.enable = false;
	bluetooth = {
	  enable = true;
	  settings.General = {
	  	Enable = "Source,Sink,Media,Socket";
	  };
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
 
  services.xserver = {
    # Enable the X11 windowing system.

    enable = true;
    displayManager.gdm.enable = true;

    #hardware.nvidia.modesetting.enable = true;
    videoDrivers = [ "nvidia" ]; #"amdgpu" ]; #
    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      enable = true;
      touchpad = {
	    naturalScrolling = true;
  	    middleEmulation = true;
  	    tapping = true;
      };
    };

    windowManager ={
      qtile.enable = true;
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib_0_17_0
          haskellPackages.xmonad-extras
          haskellPackages.xmonad_0_17_0
          haskellPackages.xmonad-utils
          haskellPackages.xmobar
          haskellPackages.dbus
          haskellPackages.List
          haskellPackages.monad-logger
        ];
      };
    };
  };

  services = {

    blueman.enable = true;
    dbus.packages = with pkgs; [ blueman ];

    physlock = {
		  enable = true;
		  allowAnyUser = true;
    };

    #pipewire conf
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      media-session.config.bluez-monitor.rules = [
        {
        # Matches all cards
          matches = [ { "device.name" = "~bluez_card.*"; } ];
          actions = {
            "update-props" = {
               "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                # mSBC is not expected to work on all headset + adapter combinations.
               "bluez5.msbc-support" = true;
               # SBC-XQ is not expected to work on all headset + adapter combinations.
               "bluez5.sbc-xq-support" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            { "node.name" = "~bluez_input.*"; }
            # Matches all outputs
            { "node.name" = "~bluez_output.*"; }
          ];
          actions = {
          	"node.pause-on-idle" = false;
          };
        }
   	  ];
    };
      #end of pipwire conf

  };



  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia.prime.offload.enable = lib.mkForce false;
      hardware.nvidia.powerManagement.enable = lib.mkForce false;
    };
  };
  virtualisation.libvirtd.enable = true;
  programs = {
    dconf.enable = true;
    nm-applet.enable = true;
    light.enable = true;
  };  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;

  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
	(nerdfonts.override { fonts = ["FiraCode"]; })
     
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

