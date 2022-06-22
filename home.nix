{ pkgs, ... }:
let
    shellAliases = {
    	  rebuild = "sudo nixos-rebuild switch --flake /home/ahmed/dotfiles/ --impure";
    	  qlog = "cat /home/ahmed/.local/share/qtile/qtile.log";
          pks = "nix search nixpkgs";
    #	  kanji = "Documents/pr/Projects/kanji/target/debug/kanji";
    };

	neovimConf = import /home/ahmed/dotfiles/nvimStuff/nvim.nix;
in {
	# Home Manager needs a bit of information about you and the
	# paths it should manage.
   	programs.neovim = neovimConf pkgs;
	home.username = "ahmed";
	home.homeDirectory = "/home/ahmed";
	programs.direnv = {
		nix-direnv.enable = true;
		enable = true;
		enableBashIntegration = true;
	};
    programs.fish = {
        enable = true;
    	inherit shellAliases;

        plugins = [
            {
              name = "z";
              src = pkgs.fetchFromGitHub {
                owner = "jethrokuan";
                repo = "z";
                rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
                sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
              };
            }
        ];
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

	#programs.neovim.enable = true;
	# Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
