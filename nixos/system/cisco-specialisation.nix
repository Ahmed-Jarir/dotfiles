{pkgs, lib, ...}:
{
  specialisation.ciscoPacketTracer = {
    configuration = let
      pkgsWithInsecure = import pkgs.path {
        inherit (pkgs) system;
        config.permittedInsecurePackages = [ "libxml2-2.13.8" ];
        config.allowUnfree = true;
      };
    in {
      environment.systemPackages = with pkgsWithInsecure; [
        ciscoPacketTracer8
      ];
    };
  };
}
