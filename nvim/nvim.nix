pkgs:
{
    enable = true;
    colorschemes.onedark.enable = true;
    globals.mapleader = " ";

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
    plugins = {
        telescope.enable = true;
        treesitter.enable = true;
        markdown-preview.enable = true;
        notify.enable = true;
        comment-nvim = {
            enable = true;
            opleader = {
                line = "<leader>c";
                block = "<leader>b";
            };
            toggler = {
                line = "<leader>cc";
                block = "<leader>bb";
            };

        };
        lualine.enable = true;
        gitsigns.enable = true;
        lsp = {
            enable = true;
            servers = {
                rnix-lsp.enable = true;
                pyright.enable = true;
                ccls.enable = true;
                lua-ls.enable = true;
                csharp-ls.enable = true;
            };
        };
        nvim-cmp = {
            enable = true;
            sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
            mapping = {
                "<tab>" = "cmp.mapping.select_next_item()";
                "<s-tab>" = "cmp.mapping.select_prev_item()";
            };
        };
        # neogen.enable = true;
    };
    extraConfigLua = ''
        local g = vim.g
        if g.neovide then
            g.neovide_scale_factor = 0.5
            g.neovide_transparency = 0.94
            g.transparency = 0.0
            g.neovide_background_color = '#222330'..math.floor(255 * g.neovide_transparency)
        else
            vim.api.nvim_set_hl(0,"Normal", { bg = "none"})
            vim.api.nvim_set_hl(0,"NormalFloat", { bg = "none"})
        end
    '';
    keymaps = [

        {
            key = "<leader>ff";
            action = "<cmd>Telescope find_files<cr>";
            options.desc = "find file";
        }
        {
          key = "<leader>fg";
          action = "<cmd>Telescope git_files<cr>";
          options.desc = "find git file";
        }
        {
            key = "<leader>fb";
            action = "<cmd>Telescope buffers<cr>";
            options.desc = "find buffer";
        }
    ];
}
