vim.cmd([[
set nocompatible
filetype off

call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'wellle/targets.vim'
Plug 'machakann/vim-sandwich'
Plug 'jiangmiao/auto-pairs'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-commentary'
Plug 'tommcdo/vim-lion'
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
call plug#end()

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
let mapleader = "\<Space>" 
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
