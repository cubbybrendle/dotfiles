call plug#begin('~/.local/share/nvim/plugged')

" Plug 'hukl/Smyck-Color-Scheme', {'as': 'smyck', 'do': 'mkdir -p colors; cp -f *.vim colors/'}

Plug 'morhetz/gruvbox'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

call plug#end()

let mapleader=" "

set termguicolors

colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='soft'

syntax on 
set number
set hidden
filetype indent on
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent
set hlsearch
