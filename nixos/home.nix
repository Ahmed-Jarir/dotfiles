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
    eclipse = {
      enable = true;
      # package = pkgs.eclipses.eclipse-java;
    };
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
    # sxhkd = {
    #   enable = false;
      # keybindings = {
      #   "XF86AudioMute" = "amixer set Master toggle";
      #   "XF86AudioRaiseVolume" = "volume-change +5";
      #   "XF86AudioLowerVolume" = "volume-change -5";
      #   "XF86AudioPlay" = "media p";
      #   "XF86AudioPause" = "media p";
      #   "XF86AudioNext" = "media n";
      #   "XF86AudioPrev" = "media b";
      #   "super + s" = "rofi -show ssh -no-parse-known-hosts -disable-history";
      #   "super + o" = "powermen";
      #   "super + p" = "rofi -show run";
      # };
    # };
  };

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
