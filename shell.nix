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
		shellInit = ''
			fish_vi_key_bindings
			set fish_greeting
            function fish_prompt

            set -l namebg '242F9B'
            set -l dirTypeBg '646FD4'
            set -l dirBg '9BA3EB'
            set -l normalFontColor '000000'
            set_color white -b $namebg

            printf ' %s ' (whoami)
            set_color normal
            set_color $namebg -b $dirTypeBg
            printf ''
            set_color $normalFontColor -b $dirTypeBg
            if [ (prompt_pwd) = '~' ]
                printf ' ~ '
                set_color $dirTypeBg -b normal
                printf ''
            else if [ (prompt_pwd) = '/' ]
                printf ' / '
                set_color $dirTypeBg -b normal
                printf ''
            else
                printf '  '
                set_color $dirTypeBg -b $dirBg
                printf ''
                set_color $normalFontColor -b $dirBg
                printf ' %s ' (prompt_pwd)
                set_color $dirBg -b normal
                printf ''
            end

            set_color normal
            end
        '';
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
