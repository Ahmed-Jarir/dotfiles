{ pkgs, ... }:
let
	neovimConf = import ./nvimStuff/nvim.nix;
in {
    
   	programs.neovim = neovimConf pkgs;
	home.username = "ahmed";
	home.homeDirectory = "/home/ahmed";
    programs = {
      direnv = {
	  	nix-direnv.enable = true;
	  	enable = true;
	  	enableBashIntegration = true;
	  };

      vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          dracula-theme.theme-dracula
          vscodevim.vim
          ms-dotnettools.csharp
        ];
      };
    };

    imports = [ 
      ./shell.nix 
      ./home-pkgs.nix
    ];

    services.udiskie.enable = true;

	home.stateVersion = "22.05";

    programs.home-manager.enable = true;
}
