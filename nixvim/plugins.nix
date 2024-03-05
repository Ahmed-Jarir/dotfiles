
{pkgs, ...}:
{
    programs.nixvim.plugins = {
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

}
