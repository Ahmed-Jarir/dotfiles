{ pkgs, ... }:
{
  systemd.user.services = {
    feh = {
      Install = { 
        WantedBy = [ "graphical-session.target" ];
      };
      Units = {
        Description = "Feh";
        After = [ "graphical-session-pre.target" ];
      };
      Service = {
        ExecStart = "${pkgs.feh}/bin/feh --randomize --no-fehbg --bg-fill ${../backgrounds}";
      };
    };
  };
}
