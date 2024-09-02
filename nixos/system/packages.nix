{pkgs, ...}:
let 
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
  #shell apps
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
   
in {
  environment.systemPackages = with pkgs; [
    # shell apps
    nvidia-offload
    volout
    powermen
    media

    # virtual machine
    # qemu
    libvirt
    ebtables
    virt-manager


    # gui tools
    rofi
    dmenu
    polybar
    xmobar
    gxmessage
    stalonetray
    # qutebrowser
    libreoffice


    # tools
    fd
    git
    zip
    unzip
    xclip
    picom 
    git-lfs
    ripgrep
    # dotnet-sdk
    alsa-utils
    python3
    brightnessctl
    xorg.xbacklight
    python39Packages.dbus-next
    qgroundcontrol

    # vim
    vim
    # clang

    # fonts 
    font-awesome

    libsForQt5.qt5.qtgraphicaleffects

    # ue4
    # pstree
    xdotool
  ];
}
