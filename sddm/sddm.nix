{ config, lib, pkgs, ... }:

let
  sddm-sugar-candy = pkgs.callPackage ./sugar_candy/sddm-sugar-candy.nix {};
in {
    services.displayManager.sddm = {
          enable = true;
          theme = "${sddm-sugar-candy}";
      wayland.enable = false;
    };
}
