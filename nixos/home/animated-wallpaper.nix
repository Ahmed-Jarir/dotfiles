{ pkgs, ... }:
let

  rgw = pkgs.writeShellScriptBin "rgw" ''
    #!/bin/bash

    if [ $(${pkgs.wmctrl}/bin/wmctrl -m | grep Name: | sed "s/Name: //")  != "qtile" ]; then
        exit 1
    fi

    # Check for arguments
     if [ $# -eq 0 ]; then
        echo "Usage: $0 <wallpaper_directory> [dimensions]"
        echo "example: $0 ~/wallpapers 1920x1080+0+0"
        exit 1
    fi

    DEFAULT_DIMENSIONS="1920x1080+0+0"

    # Set Dimensions
    if [ -z "$2" ]; then
        DIMENSIONS="$DEFAULT_DIMENSIONS"
    else
        DIMENSIONS="$2"
    fi

    if [ -d "$1" ]; then
        # Select a random file from directory
        WALLPAPER=$(${pkgs.coreutils}/bin/ls "$1" | ${pkgs.coreutils}/bin/shuf -n 1)
        WALLPAPER_PATH="$1/$WALLPAPER"
    elif [ -f "$1" ]; then
        # Use the specified file directly
        WALLPAPER_PATH="$1"
    else
        echo "Invalid file or directory: $1"
        exit 1
    fi

    if [ ! -f "$WALLPAPER_PATH" ]; then
        echo "Error: Selected wallpaper file does not exist: $WALLPAPER_PATH"
        exit 1
    fi


    # Set the selected wallpaper as the background using xwinwrap
    ${pkgs.xwinwrap}/bin/xwinwrap -ov -g "$DIMENSIONS" -- ${pkgs.mpv}/bin/mpv -wid WID "$WALLPAPER_PATH" --no-osc --no-osd-bar --loop-file --player-operation-mode=cplayer --no-audio --panscan=1.0 --no-input-default-bindings
  '';
in {
  home.packages = [rgw];
  systemd.user.services = {
    autostart-rgw = {
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Unit = {
        After = ["graphical-session-pre.target"];
        Description = "Autostart Random Gif Wallpaper";
        PartOf = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${rgw}/bin/rgw  ${../../animated_wallpapers} 1920x1080+0+0";
      };
    };
  };
}
