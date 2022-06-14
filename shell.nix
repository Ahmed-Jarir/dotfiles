{ pkgs, ... }:
let
  shellAliases = {
  	  rebuild = "sudo nixos-rebuild switch --flake /home/ahmed/dotfiles/ --impure";
  	  qlog = "cat /home/ahmed/.local/share/qtile/qtile.log";
  #	  kanji = "Documents/pr/Projects/kanji/target/debug/kanji";
  };
in {
    programs.fish = {
        enable = true;
		inherit shellAliases;
	};

    programs.bash = {
        enable = true;
		inherit shellAliases;
	};
}
