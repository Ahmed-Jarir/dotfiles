{ pkgs, ... }:
{
	imports = [
		../sddm/sddm.nix
	];
	services.xserver = {
		enable = true;

		layout = "us";
		# displayManager.gdm.enable = true;
		# displayManager.gdm.wayland = false;

		desktopManager.gnome.enable = false;

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
			xmonad = {
				enable = true;
				enableContribAndExtras = true;
				extraPackages = haskellPackages: [
					haskellPackages.xmonad-contrib
					haskellPackages.xmonad-extras
					haskellPackages.xmonad-utils
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


		upower = {
			enable = true;
			usePercentageForPolicy = true;
			percentageLow = 40;
			percentageCritical = 20;
			percentageAction = 20;
			# criticalPowerAction = "notify-send -u critical \"the battery level is below 20%\"";
			criticalPowerAction = "Hibernate";
		};
		printing.enable = true;
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
		};
		#end of pipwire conf
	};
}
