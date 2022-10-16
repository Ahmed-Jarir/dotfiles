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
    # jetbrains.pycharm-professional

    #soc
    slack
    zoom-us
    discord
    whatsapp-for-linux

    #game dev 
    unityhub
    
    # #art 
    # gimp
    # blender
    
    #music player
    cmus
    
    # cool-retro-term

	nodejs
    copyq
    trayer
  ];

}
