set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle required!
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'junegunn/vim-easy-align'
Plugin 'chriskempson/base16-vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'easymotion/vim-easymotion'
Plugin 'mattn/emmet-vim'
Plugin 'msanders/snipmate.vim'


" The bundles you install will be listed here

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

" Color
" set t_Co=256
" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif
" colorscheme base16-ocean

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

" **************
" BINDINGS
" **************
let mapleader = "\<Space>" 
nmap <leader>f :NERDTree <CR>
nmap <leader>w :w <CR>
nmap <leader>W :wq <CR>
nmap <leader>t :! python3 -m unittest discover .
nmap <Leader>s :source $MYVIMRC
nmap <leader>e :e $MYVIMRC

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Start LiveEasyAlign
nmap <leader>a <Plug>(LiveEasyAlign)


" **************
" PLUGIN OPTIONS
" **************
" limit emmet to html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
