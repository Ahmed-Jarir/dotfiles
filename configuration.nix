# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
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
  powermen = pkgs.writeShellScriptBin "powermen" ''
	#!/usr/bin/env bash
	opt=$(printf "suspend\nhibernate\npoweroff\nreboot\nlock" | rofi -dmenu -p PowerMenu)
	if [[ $opt == "poweroff" || $opt == "reboot" ]]; then
		conf=$(printf "yes\nno" | rofi -dmenu)
		if [[ $conf == "yes" ]]; then
			$(systemctl $opt) 
		else
			exit 1
		fi
	elif [[ $opt == "lock" ]]; then
		physlock
	fi
	$(systemctl $opt) 
  '';
  media = pkgs.writeShellScriptBin "media" ''
	#!/usr/bin/env bash
	if [ $# -ne 1 ]; then
		echo "no argument was given"
		exit 1
	fi
	if [[ $1 == "p" ]]; then
		${pkgs.playerctl}/bin/playerctl play-pause
	elif [[ $1 == "n" ]]; then
    	${pkgs.playerctl}/bin/playerctl next
	elif [[ $1 == "b" ]]; then
    	${pkgs.playerctl}/bin/playerctl previous
	fi
  '';

  ytmp = pkgs.writeShellScriptBin "ytmp" ''
	if [ $# -lt 1]; then 
		echo "not enough arguments"
		exit 1
	fi
	python3 /home/ahmed/Documents/pr/Projects/ytmpbash/main.py $@
  '';
in {

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
	  # vaapiVdpau
	  libvdpau-va-gl
    ];
  };
  networking.hostName = "fg002"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.

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
  services.physlock = {
		  enable = true;
		  allowAnyUser = true;
  };

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
  services.pipewire = {
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
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;

  # use the example session manager (no others are packaged yet so this is enabled by default,
  # no need to redefine it in your config for now)
  #media-session.enable = true;

  #services.blueman.enable = true;
	hardware = {
	  	pulseaudio.enable = false;
		bluetooth = {
			enable = true;
				settings.General = {
					Enable = "Source,Sink,Media,Socket";
				};
			};
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
	powermen
	media
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
	fd
	dotnet-sdk
	msbuild
    google-chrome
	qutebrowser
    nhentai
    whatsapp-for-linux
    virtmanager
	jetbrains.rider
	jetbrains.idea-ultimate
    libvirt
    qemu
    ebtables
    zoom-us
    discord
    qtile
    python3
    gnome.nautilus
	polybar
	alsa-utils
	foxitreader
	libreoffice
	brightnessctl
	xorg.xbacklight
	kitty
    alacritty
	unityhub
	git-lfs
	rofi
	maim
	xclip
	hugo
	gimp
	nodejs
	clang
	#python-with-my-packages
    ((vim_configurable.override { python = python3; }).customize{
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix coc-nvim coc-pyright coc-clangd ];
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
		inoremap <silent><expr> <TAB>
		      \ pumvisible() ? "\<C-n>" :
			        \ <SID>check_back_space() ? "\<TAB>" :
					      \ coc#refresh()
						  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

						  function! s:check_back_space() abort
						    let col = col('.') - 1
							  return !col || getline('.')[col - 1]  =~# '\s'
							  endfunction

							  " Use <c-space> to trigger completion.
							  if has('nvim')
							    inoremap <silent><expr> <c-space> coc#refresh()
								else
								  inoremap <silent><expr> <c-@> coc#refresh()
								  endif
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

