
{pkgs, ...}:
{
    programs.nixvim.plugins = {
        telescope.enable = true;
        treesitter.enable = true;
        neo-tree = {
            enable = true;
            enableGitStatus = true;
            enableModifiedMarkers = true;
            enableRefreshOnWrite = true;
        };
        markview.enable = true;
        # notify.enable = true;
        comment = {
            enable = true;
            settings = {
                opleader = {
                    line = "<leader>c";
                    block = "<leader>b";
                };
                toggler = {
                    line = "<leader>cc";
                    block = "<leader>bb";
                };
            };

        };
        lualine = {
            enable = true; 
            disabledFiletypes.statusline = [
                "neo-tree"
            ];
        };
        gitsigns.enable = true;
        lsp = {
            enable = true;
            servers = {
                # rnix-lsp.enable = true;
                pyright.enable = true;
                ccls.enable = true;
                lua-ls.enable = true;
                csharp-ls.enable = true;
            };
        };
        cmp = {
            enable = true;
            settings = {
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
        };
        copilot-cmp = {
            enable = true;
            event = [
              "InsertEnter"
              "LspAttach"
            ];
        };
        # neogen.enable = true;
    };

}
