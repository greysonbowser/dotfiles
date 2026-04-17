set nocompatible
set encoding=utf-8
if has('filetype')
  filetype indent plugin on
endif

" Enable syntax highlighting"
if has('syntax')
  syntax on
endif

set number
set wildmenu
set smartcase
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab



call plug#begin('~/.vim/plugged')


Plug 'lervag/vimtex', { 'tag': 'v2.15' }
Plug 'https://codeberg.org/ziglang/zig.vim'
Plug 'rose-pine/vim'

call plug#end()

set background=dark
colorscheme rosepine

let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_open_on_warning = 0
