{ pkgs, ... }:
{
	imports = [
		../sddm/sddm.nix
	];
	services.xserver = {
		enable = true;


		desktopManager.gnome.enable = true;
		# desktopManager.plasma6.enable = true;

		videoDrivers = [ "nvidia" ];
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
		};

		xkb = {
            options = "ctrl:nocaps";
		    layout = "us";
        };
	}; 
	console.useXkbConfig = true;

	services = {


		upower = {
			enable = true;
			usePercentageForPolicy = true;
			percentageLow = 40;
			percentageCritical = 10;
			percentageAction = 20;
			criticalPowerAction = "Hibernate";
		};
		printing.enable = true;
		blueman.enable = true;
		dbus.packages = with pkgs; [ blueman ];

		physlock = {
			enable = true;
			allowAnyUser = true;
		};
		
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
	};
}
