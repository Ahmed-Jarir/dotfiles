pkgs:
{
    enable = true;
    vimAlias = true;
    extraConfig = ''
	    luafile /home/ahmed/dotfiles/nvimStuff/nvimConfig.lua
    '';
    plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-devicons
        
        onehalf
        nvim-treesitter
        
        barbar-nvim
        coc-nvim
        coc-pyright
        coc-clangd
        nvim-lspconfig
        telescope-nvim
    ];	
}
