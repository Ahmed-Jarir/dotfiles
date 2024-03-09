{pkgs, ...}:
{
  services = {
    dunst = {
      enable = true;
    };
    sxhkd = {
      enable = true;
      keybindings = {
        "XF86AudioMute"                    = "amixer set Master toggle";
        "XF86Audio{Lower,Raise}Volume"     = "pamixer --allow-boost {--decrease,--increase} 5";
        "XF86Audio{Play,Pause,Next,Prev}"  = "media {p,p,n,b}";
        "XF86MonBrightness{Up,Down}"       = "brightnessctl set 5%{+,-}";
        "super + s"                        = "rofi -show ssh -no-parse-known-hosts -disable-history";
        "super + p"                        = "powermen";
        "super + o"                        = "rofi -show run";
        "super + shift + s"                = "${pkgs.maim}/bin/maim -s -o -D -u | xclip -selection clipboard -t image/png";
      };
    };
    syncthing.enable = true;
  };
}
