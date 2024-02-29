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

    # Get the wallpaper directory from the arguments
    WALLPAPER_DIR="$1"

    DEFAULT_DIMENSIONS="1920x1080+0+0"

    # Set Dimensions
    if [ -z "$2" ]; then
        DIMENSIONS="$DEFAULT_DIMENSIONS"
    else
        DIMENSIONS="$2"
    fi

    # Check if the directory exists
    if [ ! -d "$WALLPAPER_DIR" ]; then
        echo "Directory does not exist: $WALLPAPER_DIR"
        exit 1
    fi

    # Get absolute paths for system commands 
    # LS_PATH=$(which ls)
    # SHUF_PATH=$(which shuf)

    # Select a random wallpaper
    WALLPAPER=$(${pkgs.coreutils}/bin/ls "$WALLPAPER_DIR" | ${pkgs.coreutils}/bin/shuf -n 1)

    # Set the selected wallpaper as the background using xwinwrap
    ${pkgs.xwinwrap}/bin/xwinwrap -ov -g "$DIMENSIONS" -- ${pkgs.mpv}/bin/mpv -wid WID "$WALLPAPER_DIR/$WALLPAPER" --no-osc --no-osd-bar --loop-file --player-operation-mode=cplayer --no-audio --panscan=1.0 --no-input-default-bindings
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
        ExecStart = "${rgw}/bin/rgw  ${../animated_wallpapers} 1920x1080+0+0";
      };
    };
  };
}
