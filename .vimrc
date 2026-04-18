" Disable Vi compatibility mode
set nocompatible

set encoding=utf-8

" enable filetype specific indentation and plugins (i.e. vimtex)
filetype indent plugin on

syntax on
set number
set wildmenu
set smartcase
set ignorecase
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab


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
