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
  "scrooloose/nerdtree",
  "wellle/targets.vim",
  "machakann/vim-sandwich",
  "jiangmiao/auto-pairs",
  "chriskempson/base16-vim",
  "tpope/vim-commentary",
  "tommcdo/vim-lion",
  "sheerun/vim-polyglot",
  "w0rp/ale",
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
  "airblade/vim-gitgutter",
  "junegunn/fzf",
  "junegunn/fzf.vim",
  "tpope/vim-fugitive",
}

vim.g.mapleader = " "

require("lazy").setup(plugins, opts)

vim.cmd([[
set nocompatible
filetype off

filetype plugin indent on

" The rest of your config follows here

" **************
" VANILLA OPTIONS
" **************

set rnu " turns on relative line numbers
set nu " changes the 0 from rnu to absolute line

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

" only is case-sensitive if an uppercase letter is included
set smartcase

" macvim font
set guifont=Fira\ Code\ Regular:h16

" instant search
set incsearch 

" show char when line wraps
set showbreak=↪

" let base16colorspace=256
" colorscheme base16-material-palenight

" **************
" BINDINGS
" **************
nmap <leader>f :GFiles<CR>
nmap <leader>F :NERDTree<CR>
nmap <leader>g :Git<CR>
nmap <leader>w :w <CR>
nmap <leader>W :wq <CR>
nmap <leader>s :source $MYVIMRC <CR>
nmap <leader>e :e $MYVIMRC <CR>
nmap <leader>c :nohlsearch <CR>
nmap <leader>tn :tabnew<CR>
nmap <leader>th :tabprevious<CR>
nmap <leader>tl :tabnext<CR>


" **************
" PLUGIN OPTIONS
" **************
" prettier
let g:ale_fixers = { 'javascript': ['prettier'], 'css': ['prettier'] }
let g:ale_fix_on_save = 1

" only lint in normal mode
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1

" airline
let g:airline_theme='minimalist'
]])
