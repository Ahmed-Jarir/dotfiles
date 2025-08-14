{ pkgs, inputs, ... }:
{
  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides =  pkgs: rec{
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };
  imports = [ 
    ./shell.nix 
    ./packages.nix
    ./animated-wallpaper.nix
    ./programs.nix
    ./services.nix
    ./xdg-configs.nix
    inputs.nixvim.homeManagerModules.nixvim
    ../../nixvim
  ];
  xsession = {
    enable = true;
    initExtra = ''
      xrandr --setprovideroutputsource NVIDIA-G0 0x53 && xrandr --output eDP --auto --output HDMI-1-0 --auto --right-of  eDP
    '';
  };

  home.username = "ahmed";
  home.homeDirectory = "/home/ahmed";
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
