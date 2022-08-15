{ config, ... }:
{
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    #hardware.nvidia.modesetting.enable = true;
    videoDrivers = [ "nvidia" ]; #"amdgpu" ]; #
    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      enable = true;
      touchpad = {
	    naturalScrolling = true;
  	    middleEmulation = true;
  	    tapping = true;
      };
    };

    
    windowManager ={
      qtile.enable = true;
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib_0_17_0
          haskellPackages.xmonad-extras
          haskellPackages.xmonad_0_17_0
          haskellPackages.xmonad-utils
          haskellPackages.xmobar
          haskellPackages.dbus
          haskellPackages.List
          haskellPackages.monad-logger
        ];
      };
    };
    xkbOptions = "ctrl:nocaps";
  }; 
  console.useXkbConfig = true;

  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_13;
    };
    blueman.enable = true;
    dbus.packages = with pkgs; [ blueman ];

    physlock = {
		  enable = true;
		  allowAnyUser = true;
    };

    #pipewire conf
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      media-session.config.bluez-monitor.rules = [
        {
        # Matches all cards
          matches = [ { "device.name" = "~bluez_card.*"; } ];
          actions = {
            "update-props" = {
               "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                # mSBC is not expected to work on all headset + adapter combinations.
               "bluez5.msbc-support" = true;
               # SBC-XQ is not expected to work on all headset + adapter combinations.
               "bluez5.sbc-xq-support" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            { "node.name" = "~bluez_input.*"; }
            # Matches all outputs
            { "node.name" = "~bluez_output.*"; }
          ];
          actions = {
          	"node.pause-on-idle" = false;
          };
        }
   	  ];
    };
      #end of pipwire conf

  };
}
