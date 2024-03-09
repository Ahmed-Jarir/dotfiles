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
    neovide
    # jetbrains.idea-ultimate
    # jetbrains.idea-community
    # jetbrains.pycharm-professional

    #soc
    slack
    zoom
    # zoom-us
    # signal-desktop
    discord

    #game dev 
    # godot_4
    unityhub
    
    #art
    gimp
    # blender
    
    cmus
    # syncplay
    
    # cool-retro-term

    copyq
    trayer
    btop
    racket

    nodejs
    yarn

    brave
    # google-chrome


    # arduino
    libnotify
    pamixer
    google-chrome
    zathura
    android-studio
    # avr-sim
  ];

}
