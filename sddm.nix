{ config, lib, pkgs, ... }:

let
  sddm-sugar-candy = pkgs.callPackage ./sddmThemes/sddm-sugar-candy.nix {};
in {
  services.xserver.displayManager.sddm = {
        enable = true;
        theme = "${sddm-sugar-candy.src}";
  };
}
