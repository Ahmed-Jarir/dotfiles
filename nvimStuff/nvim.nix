pkgs:
{
    enable = true;
    vimAlias = true;
    extraConfig = ''
	    luafile /home/ahmed/dotfiles/nvimStuff/nvimConfig.lua
    '';
    plugins = with pkgs.vimPlugins; [
        onehalf
        nvim-treesitter
        vim-nix
        coc-nvim
        coc-pyright
        coc-clangd
    ];	
}
