" Disable Vi compatibility mode
set nocompatible

set encoding=utf-8

" enable filetype specific indentation and plugins (i.e. vimtex)
filetype indent plugin on

syntax on
set wildmenu
set smartcase
set ignorecase
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

" enable hybrid line numbering
set number
set relativenumber

" improve search
set incsearch
set hlsearch

set mouse=a

set clipboard=unnamedplus
set updatetime=300
set termguicolors
set cursorline
" keep a few lines visible while scrolling
set scrolloff=5

" Plugins 
call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex'
Plug 'https://codeberg.org/ziglang/zig.vim'
Plug 'rose-pine/vim'

call plug#end()

" Theming
set background=dark
colorscheme rosepine

" Configure vimtex to use zathura
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_open_on_warning = 0
