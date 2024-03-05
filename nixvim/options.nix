{pkgs, ...}:
{
    programs.nixvim = {
    
        options = {
            number = true;
            relativenumber = true;
    
            smartindent = true;
            autoindent = true;
            backspace = "indent,eol,start";
            wrap = false;
            signcolumn = "yes";
            guicursor = "i:block";
    
            tabstop = 4;
            shiftwidth = 4;
            expandtab = true;
    
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
