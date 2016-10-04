set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'
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
set rnu
set nu

" set tab length
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" colors
colorscheme base16-default-dark
let base16colorspace=256
if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
 endif


