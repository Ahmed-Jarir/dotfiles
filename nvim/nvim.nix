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

    coc-nvim
    coc-clangd
    coc-pyright
    nvim-lspconfig

    neogit
    vim-kitty-navigator
    markdown-preview-nvim

    #eye candy
    onehalf
    dashboard-nvim
    lualine-nvim
    nvim-web-devicons
    (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
    (pkgs.fetchFromGitHub {
      owner = "xiyaowong";
      repo = "nvim-transparent";
      rev = "1a3d7d3b7670fecbbfddd3fc999ddea5862ac3c2";
      sha256 = "sha256-ollCztmgulpMTyoks9ENMSmzE52dF9sMXti9ZF1SHnE=";
    })
  ];	
}
