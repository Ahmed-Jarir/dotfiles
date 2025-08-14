{pkgs, ...}:
{
    programs.nixvim = {
    
        opts = {
            number = true;
            relativenumber = true;
    
            smartindent = true;
            autoindent = true;
            wrap = false;
            signcolumn = "yes";
            guicursor = "i:block";
            cursorline = true;
    
            termguicolors = true;
            title = true; 
    
            clipboard = "unnamedplus";
    
            mouse = "a";
    
            smartcase = true;
    
            ttimeoutlen = 5;
    
            compatible = false;
    
            autoread = true;
    
            incsearch = true;
            ignorecase = true;
    
            hidden = true;
    
            shortmess = "A";
    
            undofile = true;
            backup = false;
            swapfile = false;
    
        };
    };
}
