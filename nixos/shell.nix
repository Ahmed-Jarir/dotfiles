{ pkgs, ... }:
let
  shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/ahmed/dotfiles/nixos/";
      qlog = "cat /home/ahmed/.local/share/qtile/qtile.log";
      pks = "nix search nixpkgs";
      nflake = "nix flake new -t github:nix-community/nix-direnv ./";
  };
in {
    programs.fish = {
        enable = true;
        inherit shellAliases;
        shellInit = ''

            set fish_cursor_default block blink
            set fish_cursor_insert  block blink
            set fish_greeting
            set -U namebg '242F9B'
            set -U dirTypeBg '646FD4'
            set -U dirBg '9BA3EB'
            set -U gitBg 'DBDFFD'
            set -U normalFontColor '000000'
            
            function fish_prompt
                #set_color white -b $namebg
                #printf ' %s ' (whoami)
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
                    git status > /dev/null 2>&1
                    if [ $status -eq 0 ]
                        set_color $dirBg -b $gitBg
                        printf ''
                        set_color $normalFontColor -b $gitBg
                        printf '  '
                        set_color $gitBg -b normal
                        printf ''
                    else 
                        set_color $dirBg -b normal
                        printf ''
                    end
              end
              printf " "
            end
			fish_vi_key_bindings
            function fish_mode_prompt --description 'Displays the current mode'
                set_color --bold white -b $namebg
                switch $fish_bind_mode
                    case default
                        printf '  '
                    case insert
                        printf ' 󰘎 '
                    case replace_one
                        printf '  '
                    case visual
                        printf ' 󰈈 '
                    case '*'
                        printf '  '
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
