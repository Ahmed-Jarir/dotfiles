{pkgs, ...}:
{
  xdg = {
    enable = true;
    configFile = {
      kitty = {
        source = ../../kitty;
        target = "kitty";
        recursive = true;
      };
      qtile = {
        source = ../../qtile;
        target = "qtile";
        recursive = true;
      };
      xmonad = {
        source = ../../xmonad;
        target = "xmonad";
        recursive = true;
      };
    };
  };
}
