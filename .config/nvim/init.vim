" => VIM config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load ~/.vimrc config
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

" => Plugin options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
execute pathogen#infect()
call plug#begin('~/dotfiles/.config/nvim/plugged')
    Plug 'junegunn/goyo.vim'
cal plug#end()

" => Goyo Options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>


