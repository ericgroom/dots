set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'
Plugin 'klen/python-mode'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-surround'

" The bundles you install will be listed here

filetype plugin indent on

" The rest of your config follows here
set rnu
set nu

" set tab length
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
