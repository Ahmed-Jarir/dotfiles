{ pkgs, inputs, ... }:
let
  #shell apps
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
		conf=$(printf "yes\nno" | rofi -dmenu -p confirm)
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

  #hard coded path is temporary
  #end of shell apps

in {

  environment.systemPackages = with pkgs; [

	#shell packages
    nvidia-offload
	volume-change
	volout
	powermen
	media


	#virtual machine
    qemu
    libvirt
    ebtables
    virtmanager


	#gui tools
	rofi
    dmenu
    xmobar
	polybar
    gxmessage
    notify-osd
    stalonetray
	qutebrowser
	foxitreader
	libreoffice
    google-chrome
    gnome.nautilus



	#tools
	fd
    git
	maim
	xclip
    compton
	git-lfs
    ripgrep
    msbuild
    nitrogen
	dotnet-sdk
	alsa-utils
    python39Full
	brightnessctl
	xorg.xbacklight
	python39Packages.dbus-next

	#vim
	clang
	nodejs

    #fonts 
    font-awesome

    libsForQt5.qt5.qtgraphicaleffects
  ];
}
