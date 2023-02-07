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
    ytmp
    check-volout
    # 

    #ides
    # jetbrains.clion
    # jetbrains.rider
    # jetbrains.idea-ultimate
    jetbrains.idea-community
    # jetbrains.pycharm-professional

    #soc
    slack
    zoom-us
    discord

    #game dev 
    
    #art
    gimp
    # blender
    
    #music player
    cmus
    
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
  ];

}
