local opt = vim.opt
local g = vim.g

vim.cmd [[
    set nowrap
    set noswapfile
    set noerrorbells

    colorscheme onehalfdark
    set backspace=indent,eol,start
    map ; :
]]

require('nvim_comment').setup({
      marker_mapping = true

    , comment_empty_trim_whitespace = false 
    -- Should key mappings be created
    , create_mappings = true
    , comment_empty = false
    , line_mapping = "<leader>lc", operator_mapping = "<leader>c", comment_chunk_text_object = "ic"
})
g.mapleader = ' '

opt.smartindent = true
opt.autoindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.clipboard = "unnamedplus"
opt.mouse = "a"

opt.number = true

opt.smartcase = true
opt.ttimeoutlen = 5
opt.compatible = false
opt.autoread = true
opt.incsearch = true
opt.hidden = true
opt.shortmess = "A"

