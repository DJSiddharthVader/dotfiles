" => VIM config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source $HOME/.vimrc
nnoremap <silent> <leader>f :Format<CR>
filetype plugin on
filetype indent on
" => Manage Plugins (vim-plug)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable plugins
call plug#begin('~/dotfiles/.config/nvim/plugged')
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'
    " Plug 'lervag/vimtex'
    Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'vim-syntastic/syntastic'
    Plug 'mhartington/formatter.nvim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mhinz/vim-startify'
    Plug 'tpope/vim-commentary'
    " Plug 'Vigemus/iron.nvim'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'R-nvim/cmp-r'
    Plug 'R-nvim/R.nvim'
call plug#end()
" => Goyo + Limelight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<bar> Limelight!!<cr>
" => Pandoc markdown
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_markdown_math = 1
let g:markdown_fenced_languages = ['css','json=javascript', 'ruby', 'xml', 'python', 'go','tex']
let g:pandoc#syntax#codeblocks#embeds#langs = ["ruby","literatehaskell=lhaskell", "bash=sh","go"]
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
au Filetype markdown.pandoc PandocFolding syntax
" => Syntastic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:pymode_python = 'python3'
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_pylint_args='--disable=missing-docstring --errors-only'
" let g:syntastic_go_checkers= ['go', 'gofmt', 'govet']
let g:syntastic_enable_r_lintr_checker = 1
let g:syntastic_R_checkers= ['lintr']
" let g:syntastic_markdown_checkers= ['mdl', 'proselint']
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
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 1
let g:airline_stl_path_style = 'short'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
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
" => pydocstring
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType python setlocal tabstop=4 shiftwidth=4 smarttab expandtab
let g:pydocstring_formatter = 'sphinx'
nnoremap <silent> <leader>pd :Pydocstring<cr>
" => tree-sitter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
lua << EOF
require'nvim-treesitter.configs'.setup {
  auto_install = true,
  ensure_installed = { "r", "markdown_inline", "markdown", "rnoweb" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
      enable = true
  }
}
EOF
" => R.nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let maplocalleader=';'
let config_tmux='false'
let close_term='false'
let R_set_omnifunc = ["R", "rmd", "rnoweb", "rhelp", "rrst"]
let R_auto_omni = ["R",  "rmd", "rnoweb", "rhelp", "rrst"]
let r_syntax_folding = 1
nmap <Space> <Plug>RDSendLine
vmap <Space> <Plug>RDSendSelection
let assignment_keymap = '<LocalLeader>-'
let pipe_keymap = '<LocalLeader>>'
let pipe_version = 'magrittr'
lua << EOF
    require("r").setup({ 
        setwd = 'file',
        assignment_keymap = '<LocalLeader>a',
        pipe_keymap = '<LocalLeader>m',
        pipe_version = 'magrittr',
    })
    hook = {
    on_filetype = function()
       -- Creating maps to "<Plug>RDSendLine" and "<Plug>RSendSelection"
       -- will prevent R.nvim of creating its default maps to them.
        vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
        vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
    end,
    }
EOF
" => LSP options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
lua << EOF
require'lspconfig'.jedi_language_server.setup{}
-- ALL Copied from nvim-lspconfig github
local nvim_lsp = require('lspconfig')
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  local opts = { noremap=true, silent=true }
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<leader>h', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>]d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader><C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader><space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader><space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader><space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader><space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
end
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'jedi_language_server' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
-- for automatic code formatting for python
home = os.getenv("HOME")
require("formatter").setup({
  filetype = {
    python = {
      function()
        return {
          exe = home .. "/anaconda3/bin/python -m autopep8",
          args = {
            "--in-place --aggressive --aggressive",
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
          },
          stdin = false
        }
      end
    }
  }
})
EOF
