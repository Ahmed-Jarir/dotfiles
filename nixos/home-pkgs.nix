{ pkgs, ... }:
{
  
  home.packages = with pkgs; [
    ytmp
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
  ];

}
