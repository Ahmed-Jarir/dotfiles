pkgs:
{
  enable = true;
  vimAlias = true;
  extraConfig = ''
   luafile /home/ahmed/dotfiles/nvim/nvim.lua
  '';
  plugins = with pkgs.vimPlugins; [

    vim-nix
    nvim-comment
    telescope-nvim

    nvim-lspconfig
    nvim-cmp
    cmp-nvim-lsp
    cmp-nvim-ultisnips
    telescope-ultisnips-nvim
    ultisnips

    neogit
    gitsigns-nvim
    vim-kitty-navigator
    markdown-preview-nvim

    #eye candy
    onehalf
    dashboard-nvim
    lualine-nvim
    indent-blankline-nvim
    nvim-web-devicons
    # (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
    (pkgs.fetchFromGitHub {
      owner = "xiyaowong";
      repo = "nvim-transparent";
      rev = "1a3d7d3b7670fecbbfddd3fc999ddea5862ac3c2";
      sha256 = "sha256-ollCztmgulpMTyoks9ENMSmzE52dF9sMXti9ZF1SHnE=";
    })
  ];	
  extraPackages = with pkgs; [
    ripgrep
    fd

    lua-language-server
    ccls
    pyright
    rnix-lsp
  ];
}
