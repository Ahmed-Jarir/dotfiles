pkgs:
{
    enable = true;
    colorschemes.onedark.enable = true;
    globals.mapleader = " ";


    #extraPlugins = with pkgs.vimPlugins; [
    
    #]
    options = {
        number = true;
        relativenumber = true;
        ignorecase = true;
        smartindent = true;
        autoindent = true;
        tabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        termguicolors = true;
        clipboard = "unnamedplus";
        mouse = "a";
        smartcase = true;
        ttimeoutlen = 5;
        compatible = false;
        autoread = true;
        incsearch = true;
        hidden = true;
        shortmess = "A";
    };
    plugins = {
        telescope.enable = true;
        treesitter.enable = true;
        comment-nvim = {
            enable = true;
            opleader = {
                line = "<leader>c";
                block = "<leader>cb";
            };
        };
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


# nowrap = true;
# signcolumn = true;
# noswapfile = true;
# noerrorbells = true;

  
  # vimAlias = true;
  # extraConfig = ''
  #   luafile ${./init.lua}
  #   luafile ${./plugins/init.lua}
  # '';
  # plugins = with pkgs.vimPlugins; [

  #   vim-nix
  #   nvim-comment
  #   telescope-nvim

  #   nvim-lspconfig
  #   nvim-cmp
  #   cmp-nvim-lsp
  #   cmp-nvim-ultisnips
  #   telescope-ultisnips-nvim
  #   ultisnips

  #   neogit
  #   gitsigns-nvim
  #   vim-kitty-navigator
  #   markdown-preview-nvim

  #   #eye candy
  #   onehalf
  #   dashboard-nvim
  #   lualine-nvim
  #   #indent-blankline-nvim
  #   nvim-web-devicons
  #   # (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
  #   (pkgs.fetchFromGitHub {
  #     owner = "xiyaowong";
  #     repo = "nvim-transparent";
  #     rev = "1a3d7d3b7670fecbbfddd3fc999ddea5862ac3c2";
  #     sha256 = "sha256-ollCztmgulpMTyoks9ENMSmzE52dF9sMXti9ZF1SHnE=";
  #   })
  # ];
  # extraPackages = with pkgs; [
  #   ripgrep
  #   fd

  #   lua-language-server
  #   ccls
  #   pyright
  #   rnix-lsp
  # ];
}
