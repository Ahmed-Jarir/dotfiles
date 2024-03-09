{pkgs, ...}:
{
  programs = {
    kitty.enable = true;
    direnv = {
      nix-direnv.enable = true;
      enable = true;
      enableBashIntegration = true;
    };
  };
}
