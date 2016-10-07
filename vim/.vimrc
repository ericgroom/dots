set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle required!
Plugin 'VundleVim/Vundle.vim'
Plugin 'klen/python-mode'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-surround'
Plugin 'chriskempson/base16-vim'

" The bundles you install will be listed here

call vundle#end()
filetype plugin indent on

" The rest of your config follows here

set rnu " turns on relative line numbers
set nu " changes the 0 from rnu to absolute line

" adds kspell to complete which completes dictionary words
" when spell check is enabled
set complete=.,w,b,u,t,i,kspell 

" set tab length
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" disable ex mode, feel free to remap later
map Q <Nop>

" colors
colorscheme base16-ocean
let base16colorspace=256
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
 endif

" bindings
let mapleader = "\<Space>" 
map <leader>f :NERDTree <CR>
map <leader>w :w <CR>
