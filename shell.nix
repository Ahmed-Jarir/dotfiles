{ pkgs, ... }:
let
  shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/ahmed/dotfiles/ --impure";
      qlog = "cat /home/ahmed/.local/share/qtile/qtile.log";
      pks = "nix search nixpkgs";
      xConf = "vim /home/ahmed/.xmonad/xmonad.hs";
      qConf = "vim .config/qtile/config.py";
  #	  kanji = "Documents/pr/Projects/kanji/target/debug/kanji";
  };
in {
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
}
