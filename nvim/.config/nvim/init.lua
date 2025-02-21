vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.relativenumber = true
vim.opt.number = true

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "chriskempson/base16-vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[
        set termguicolors
        colorscheme base16-material-palenight
      ]])
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>F", "<cmd>NvimTreeFindFileToggle<cr>", desc = "NvimTree" }
    },
    config = function()
      require("nvim-tree").setup()
    end
  },
  {
      "nvim-telescope/telescope.nvim",
      keys = {
        { "<leader>f", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
        { "<leader>s", "<cmd>Telescope<cr>", desc = "Telescope"},
        { "<leader>o", "<cmd>Telescope live_grep<cr>", desc = "Grep"},
        { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      }
  },
  "wellle/targets.vim",
  "machakann/vim-sandwich",
  "jiangmiao/auto-pairs",
  "tpope/vim-commentary",
  "tommcdo/vim-lion",
  "nvim-treesitter/nvim-treesitter",
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
  "airblade/vim-gitgutter",
  "tpope/vim-fugitive",
}

require("lazy").setup(plugins, opts)

vim.cmd([[
set nocompatible
filetype off

filetype plugin indent on

" The rest of your config follows here

" **************
" VANILLA OPTIONS
" **************

" adds kspell to complete which completes dictionary words
" when spell check is enabled
set complete=.,w,b,u,t,i

" set tab length
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" disable ex mode, feel free to remap later
map Q <Nop>

" syntax 
syntax on

" instant search
set incsearch 

" show char when line wraps
set showbreak=↪

" **************
" BINDINGS
" **************
nmap <leader>g :Git<CR>
nmap <leader>w :w <CR>
nmap <leader>W :wq <CR>
nmap <leader>c :nohlsearch <CR>
nmap <leader>tn :tabnew<CR>
nmap <leader>th :tabprevious<CR>
nmap <leader>tl :tabnext<CR>


" **************
" PLUGIN OPTIONS
" **************
" airline
let g:airline_theme='minimalist'
]])
