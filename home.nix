{ pkgs, ... }:
let
	shellAliases = {
		rebuild = "sudo nixos-rebuild switch --flake /home/ahmed/dotfiles/";
	};
in {
	# Home Manager needs a bit of information about you and the
	# paths it should manage.
	home.username = "ahmed";
	home.homeDirectory = "/home/ahmed";
	programs.direnv = {
		nix-direnv.enable = true;
		enable = true;
		enableBashIntegration = true;
	};
	programs.bash = {
		enable = true;
		inherit shellAliases;
	};

	# This value determines the Home Manager release that your
	# configuration is compatible with. This helps avoid breakage
	# when a new Home Manager release introduces backwards
	# incompatible changes.
	#
	# You can update Home Manager without changing this value. See
	# the Home Manager release notes for a list of state version
	# changes in each release.
	home.stateVersion = "22.05";

	programs.neovim.enable = true;
	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
