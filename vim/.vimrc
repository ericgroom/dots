set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle required!
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-ragtag'
Plugin 'junegunn/vim-easy-align'
Plugin 'chriskempson/base16-vim'

" The bundles you install will be listed here

call vundle#end()
filetype plugin indent on

" The rest of your config follows here

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

" bindings
let mapleader = "\<Space>" 
map <leader>f :NERDTree <CR>
map <leader>w :w <CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Start LiveEasyAlign
nmap <leader>a <Plug>(LiveEasyAlign)

" RagTag
let g:ragtag_global_maps = 1

" Color
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
colorscheme base16-ocean

" syntax 
syntax on

" color
set t_Co=16
