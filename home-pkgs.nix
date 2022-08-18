{ pkgs, ... }:
let 
  ytmpMenu = pkgs.writeShellScriptBin "ytmpMenu" ''
	opt=$(printf "audio\nvideo" | rofi -dmenu -p flag)

	if [[ $opt == "audio" || $opt == "video" ]]; then
      links=$(rofi -dmenu -p links)
      ytmp --$opt $links
          
    fi
  '';
in {
  
  home.packages = with pkgs; [
    ytmp
    
	#shell packages
    ytmpMenu

	#ides
    jetbrains.clion
    jetbrains.rider
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional

	#soc
    zoom-us
    discord
    whatsapp-for-linux

    #game dev 
	unityhub

	#art 
	gimp
	blender

	#terminals
	kitty

    #db plat
    pgadmin4

    #music player
    mpd
    mpc-cli
    ncmpcpp


    #website testing
    soapui
    jmeter

    cool-retro-term

  ];
}
