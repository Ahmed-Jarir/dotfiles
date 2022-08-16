pkgs:
{
    enable = true;
    vimAlias = true;
    extraConfig = ''
	    luafile /home/ahmed/dotfiles/nvimStuff/nvimConfig.lua
    '';
    plugins = with pkgs.vimPlugins; [

        vim-nix
        barbar-nvim
        coc-nvim
        coc-pyright
        coc-clangd
        nvim-lspconfig
        telescope-nvim
        nvim-comment

        neogit

        vim-kitty-navigator

        #eye candy
        onehalf
        lualine-nvim
        nvim-web-devicons
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        (pkgs.fetchFromGitHub {
          owner = "xiyaowong";
          repo = "nvim-transparent";
          rev = "1a3d7d3b7670fecbbfddd3fc999ddea5862ac3c2";
          sha256 = "sha256-ollCztmgulpMTyoks9ENMSmzE52dF9sMXti9ZF1SHnE=";
        })
    ];	
}
