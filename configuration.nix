# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
  volume-change = pkgs.writeShellScriptBin "volume-change" ''
	# Check if argument exists
	if [ $# -ne 1 ]; then
		echo "Usage: $0 <amount>"
		exit 1
	fi
	# Check if argument is a number
	if ! [ "$1" -eq "$1" ] 2> /dev/null; then
		echo "<amount> should be an integer."
	fi
	amount=$1
	current_level=$(${pkgs.alsa-utils}/bin/amixer -M get Master | grep -oE "[0-9]+%" | sed "s/%//" | head -n 1)
	new_level=$((current_level + amount))
	if [ "$new_level" -lt 0 ]; then
		new_level=0
	fi
	new_level_percentage=$new_level
	# Convert new level to a linear factor
	new_level=$(echo "scale=2;" "$new_level / 100;" | ${pkgs.bc}/bin/bc | sed "s/^\./0./")
	${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ "$new_level"
	echo "Changed volume to $new_level_percentage%."
  '';
  volout = pkgs.writeShellScriptBin "volout" ''
	if [ $# -ne 1 ]; then
		${pkgs.pulseaudio}/bin/pactl list sinks short
		exit 1
	fi
	${pkgs.pulseaudio}/bin/pactl set-default-sink $1
  '';
  #my-python-packages = python-packages: with python-packages; [ 
  #  youtube_dl
  #];
  #python-with-my-packages = python3.withPackages my-python-packages;
  ytmp = pkgs.writeShellScriptBin "ytmp" ''
	if [ $# -lt 1]; then 
		echo "not enough arguments"
		exit 1
	fi
	python3 /home/ahmed/Documents/pr/projects/ytmpbash/main.py $@
  '';
in {


  services.openvpn.servers = {
    officeVPN  = { config = '' config /root/nixos/openvpn/officeVPN.conf ''; };
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
# systemd.services.blueman = {
#	script = ''
#	  systemctl --machine=<user>@.host --user start blueman-applet
#	'';
#	wantedBy = [ "multi-user.target" ];
#  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides =  pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    unstable = import unstableTarball {
      config = config.nixpkgs.config;
    };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  networking.hostName = "fg002"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
 
  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.windowManager.qtile.enable = true;

  #hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

hardware.nvidia.prime = {
  offload.enable = true;

  # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
  amdgpuBusId = "PCI:5:0:0";

  # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
  nvidiaBusId = "PCI:1:0:0";
};

  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia.prime.offload.enable = lib.mkForce false;
      hardware.nvidia.powerManagement.enable = lib.mkForce false;
    };
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  #services.blueman.enable = true;
  security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# Enable JACK applicaitons
		# jack.enable = true;

		# Bluetooth Configuration
		media-session.config.bluez-monitor.rules = [{
			# Match all cards
			matches = [ { "device.name" = "~bluez_card.*"; } ];
			actions = {
				"update-props" = {
					"bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
					"bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
					# mSBC is not expected to work on all headset + adapter combinations.
					"bluez5.msbc-support" = true;
					# SBC-XQ is not expected to work on all headset + adapter combinations.
					"bluez5.sbc-xq-support" = true;
				};
			};
		} {
			matches = [
				# Match all sources
				{ "node.name" = "~bluez_input.*"; }
				# Match all outputs
				{ "node.name" = "~bluez_output.*"; }
			];
			actions = {
				"node.pause-on-idle" = false;
			};
		}];
	};
  # Enable touchpad support (enabled default in most desktopManager).

  services.xserver.libinput.touchpad = {
		naturalScrolling = true;
  		middleEmulation = true;
  		tapping = true;
  };
  services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ahmed = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ]; # Enable ‘sudo’ for the user.
  };
  time.timeZone = "Europe/Istanbul";

  programs.nm-applet.enable = true;
  services.blueman.enable = true;
  programs.light.enable = true;

  environment.variables = {
		#BROWSER = "google-chrome";
    	TERMINAL = "alacritty";
		EDITOR = "vim";
  };


  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nvidia-offload
	volume-change
	volout
	ytmp
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    google-chrome
    nhentai
    whatsapp-for-linux
    virtmanager
    libvirt
    qemu
    ebtables
    zoom-us
    unstable.discord
    qtile
    python3
    unstable.steam
    gnome.nautilus
	polybar
	alsa-utils
	foxitreader
	libreoffice
	brightnessctl
	xorg.xbacklight
    alacritty
	openvpn
	rofi
	nodejs
	#python-with-my-packages
    ((vim_configurable.override { python = python3; }).customize{
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix coc-nvim coc-pyright ];
        opt = [];
      };
      vimrcConfig.customRC = ''
		set number
		set tabstop=4
		set nowrap
		set nocompatible
		set backspace=indent,eol,start
	
		syntax on
		
		filetype indent on 
      '';
    })

  ];
  fonts.fonts = with pkgs; [
	(nerdfonts.override { fonts = ["FiraCode"]; })
  ];
  services.dbus.packages = with pkgs; [ blueman ];

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
  networking.networkmanager.enable = true;
  hardware.firmware = [ pkgs.rtw89-firmware ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

