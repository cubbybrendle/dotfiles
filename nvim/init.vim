call plug#begin('~/.local/share/nvim/plugged')

Plug 'morhetz/gruvbox'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

call plug#end()

"let mapleader=" "
map <Space> <Leader>

set termguicolors

colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark='soft'

syntax on 
filetype indent on

set autoindent
set expandtab
set hidden
set hlsearch
set mouse=a
set number
set nowrap
set shiftwidth=2
set showcmd
set smartindent
set tabstop=2
