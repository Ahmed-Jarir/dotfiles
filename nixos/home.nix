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
  };
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

  imports = [ 
    ./shell.nix 
    ./home-pkgs.nix
    ./sysdservices.nix
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
