
{pkgs, ...}:
{
    programs.nixvim.plugins = {

        auto-save = {
            enable = true;
        };
        telescope.enable = true;
        treesitter.enable = true;
        neo-tree = {
            enable = true;
            enableGitStatus = true;
            enableModifiedMarkers = true;
            enableRefreshOnWrite = true;
        };
        markview = {
            enable = true;
            # settings = {
            #     hybrid_modes = [
            #       "i"
            #       "r"
            #       "v"
            #     ];
            #     mode = [
            #       "i"
            #       "n"
            #       "v"
            #     ];
            # };
        };
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
        illuminate = {
            enable = true;
            providers = [
              "lsp"
              "treesitter"
              "regex"
            ];
            delay = 100;
            underCursor = true;
        };
        lualine = {
            enable = true; 
            settings.options.disabled_filetypes.statusline = [
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
                lua_ls.enable = true;
                csharp_ls.enable = true;
                ts_ls.enable = true;
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
            settings.event = [
              "InsertEnter"
              "LspAttach"
            ];
        };
        sleuth = {
            enable = true;
            autoLoad = true;
        };
        # neogen.enable = true;
        web-devicons.enable = true;
    };


}
