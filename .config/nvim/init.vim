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
" Enable filetype plugins
filetype plugin on
filetype indent on

call plug#begin('~/dotfiles/.config/nvim/plugged')
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer'
    Plug 'lervag/vimtex'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'vim-syntastic/syntastic'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mhinz/vim-startify'
    Plug 'tpope/vim-commentary'
    "Plug 'kabouzeid/nvim-lspinstall'
    "Plug 'neoclide/coc.nvim', {'branch': 'release'}
cal plug#end()

" => Goyo + Limelight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<bar> Limelight!!<cr>
" => Vimtex
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimtex_mappings_enabled = 0
let g:vimtex_view_general_viewer = 'open'
let g:vimtex_view_general_options = '-a zathura'
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
let g:vim_markdown_math = 1
" => Pandoc markdown
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_markdown_math = 1
let g:markdown_fenced_languages = ['css','json=javascript', 'ruby', 'xml', 'python', 'go','tex']
let g:pandoc#syntax#codeblocks#embeds#langs = ["ruby","literatehaskell=lhaskell", "bash=sh","go"]

augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
" => Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pymode_python = 'python3'
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_exec='/home/sidreed/anaconda3/bin/flake8'
let g:syntastic_python_pylint_exec='/home/sidreed/anaconda3/bin/pylint'
let g:syntastic_python_pylint_args='--disable=missing-docstring --errors-only'
let g:syntastic_go_checkers= ['go', 'gofmt', 'govet']
let g:syntastic_enable_r_lintr_checker = 1
let g:syntastic_R_checkers= ['lintr']
let g:syntastic_markdown_checkers= ['mdl', 'proselint']
let g:syntastic_tex_checkers= ['chktex', 'proselint']
let g:syntastic_bash_checkers= ['shellcheck']

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" => Airline
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %l,%c\ \ %{HasPaste()}%F%m%r%h\ %w "CWD:\ %r%{getcwd()}%h\ \
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"let g:airline_theme="wal_airline"
let g:airline_theme="wal"
" since these does not auto update an open nvim instances colors using 
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_stl_path_style = 'short'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts=1
"let g:airline#extensions#tabline#formatter = 'unique_tail'
" => Startify
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Custom Header
let g:startify_custom_header = [
      \ '                                             ',
      \ '      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~          ',
      \ '     {  "The more you use VIM the  }         ',
      \ '     {  the less you use VIM."     }         ',
      \ '     {       -- DJSiddharthVader   }         ',
      \ '      ~~~~~~~~~    ~~~~~~~~~~~~~~~~          ',
      \ '               \  /                          ',
      \ '                \ \  ___                     ',
      \ '                    (-_-)                    ',
      \ '                    _) (_                    ',
      \ '                   /     \                   ',
      \ '                 _( \_ _/ )_                 ',
      \ '                (_____\_____)                ',
      \ '                                             ',
      \ ]
" => LSP options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Key bindings
"nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
"nnoremap <silent> gh     <cmd>lua vim.lsp.buf.hover()<CR>
"nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
"nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
"nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
"nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
