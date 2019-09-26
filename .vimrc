set number
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set t_ut=""

set colorcolumn=81
au BufRead,BufNewFile *.asm set filetype=nasm

set nocompatible
set shell=/bin/sh
filetype plugin on
let g:go_disable_autoinstall = 0
let g:vim_json_syntax_conceal = 0
colorscheme Monokai
