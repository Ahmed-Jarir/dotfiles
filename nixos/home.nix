{ pkgs, ... }:
let
  neovimConf = import ../nvim/nvim.nix;
in {

  home.username = "ahmed";
  home.homeDirectory = "/home/ahmed";
  programs = {
    kitty.enable = true;
    neovim = neovimConf pkgs;
    direnv = {
      nix-direnv.enable = true;
      enable = true;
      enableBashIntegration = true;
    };
    
    # thunar.enable = true;
  };
  imports = [ 
    ./shell.nix 
    ./home-pkgs.nix
    ./sysdservices.nix
  ];
  #configs#
  xdg = {
    enable = true;
    configFile = {
      kitty = {
        source = ../kitty;
        target = "kitty";
        recursive = true;
      };
      qtile = {
        source = ../qtile;
        target = "qtile";
        recursive = true;
      };
      xmonad = {
        source = ../xmonad;
        target = "xmonad";
        recursive = true;
      };
    };
  };
  #end configs#
  services = {
    dunst = {
      enable = true;
    };
    sxhkd = {
      enable = true;
      keybindings = {
        "XF86AudioMute"        = "amixer set Master toggle";
        "XF86AudioRaiseVolume" = "volume-change +5";
        "XF86AudioLowerVolume" = "volume-change -5";
        "XF86AudioPlay"        = "media p";
        "XF86AudioPause"       = "media p";
        "XF86AudioNext"        = "media n";
        "XF86AudioPrev"        = "media b";
        "super + s"            = "rofi -show ssh -no-parse-known-hosts -disable-history";
        "super + p"            = "powermen";
        "super + o"            = "rofi -show run";
        "super + shift + s"    = "maim -s -o -D -u | xclip -selection clipboard -t image/png";
      };
    };
  };

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
