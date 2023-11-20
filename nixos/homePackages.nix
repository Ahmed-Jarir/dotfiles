{ pkgs, ... }:
let
  check-volout = pkgs.writeShellScriptBin "check-volout" ''
    if [[ $(${pkgs.pulseaudio}/bin/pactl list sinks | grep Active\ Port | sed "s/.*speaker/speaker/") == "speaker" ]]; then 
        echo "true"
    else
        echo "false"
    fi
  '';
in{
  
  home.packages = with pkgs; [
    # ytmp
    # rgw
    check-volout
    # 

    #ides
    # jetbrains.clion
    jetbrains.rider
    # jetbrains.idea-ultimate
    # jetbrains.idea-community
    jetbrains.pycharm-professional

    #soc
    slack
    zoom-us
    discord

    #game dev 
    godot_4
    unityhub
    
    #art
    gimp
    # blender
    
    cmus
    mpv
    syncplay
    
    # cool-retro-term

    copyq
    trayer
    btop
    racket

    neovide

    nodejs
    yarn

    brave
    # google-chrome


    arduino
    libnotify
    xfce.thunar
    pamixer
    google-chrome
    signal-desktop
    yuzu-mainline
    zathura
    android-studio
    mpv
    xwinwrap
  ];

}
