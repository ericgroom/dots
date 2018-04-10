set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'wellle/targets.vim'
Plugin 'machakann/vim-sandwich'
Plugin 'jiangmiao/auto-pairs'
Plugin 'mattn/emmet-vim'
Plugin 'chriskempson/base16-vim'
Plugin 'tpope/vim-commentary'
Plugin 'tommcdo/vim-lion'
Plugin 'sheerun/vim-polyglot'


call vundle#end()
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
set guifont=Monaco:h12

" instant search
set incsearch 

" show char when line wraps
set showbreak=↪

colorscheme base16-material-palenight

" **************
" BINDINGS
" **************
let mapleader = "\<Space>" 
nmap <leader>f :NERDTree <CR>
nmap <leader>w :w <CR>
nmap <leader>W :wq <CR>
nmap <leader>t :! python3 -m unittest discover .
nmap <Leader>s :source $MYVIMRC <CR>
nmap <leader>e :e $MYVIMRC <CR>

" **************
" PLUGIN OPTIONS
" **************
" limit emmet to html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
