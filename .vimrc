" => VIM config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=1000

" Sets how many lines of history VIM has to remember
set history=500

" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

"show pressed keys
set showcmd

"Always show current position
set ruler

" Highlight current line
set cursorline

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif
set mouse=
"turns on spell check
autocmd FileType latex,tex setlocal spell

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turn on syntax highlighting
syntax on
set background=dark

" Add line numbers
set number

" makes all relative except for current line
set relativenumber

" Add a bit extra margin to the left
set foldcolumn=1

"set folding to save/load automatically
function! LoadView() abort
    try
        loadview
    catch /E484/
        return
    endtry
endfunction

autocmd BufWinEnter * call LoadView()
autocmd BufWinLeave *.* mkview

" what is displayed in folded lines
function! MyFoldText()
    let nl = v:foldend - v:foldstart + 1
    let comment = substitute(getline(v:foldstart),"^ *","",1)
    let linetext = substitute(getline(v:foldstart+1),"^ *","",1)
    "let txt = '+ ' . linetext . ' : "' . comment . '" : length ' . nl
    let txt = '+ ' . comment . ' : '. nl . ' : '  . linetext
    return txt
endfunction
set foldtext=MyFoldText()

" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
"colorscheme hybrid
"colorscheme new-railscasts
colorscheme anderson
colorscheme angr

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>wm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Set font according to system
if has("linux")
    set gfn=Hack\ Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("unix")
    set gfn=Monospace\ 11
endif

" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc anyway...
set nobackup
set nowb
set noswapfile

" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Linebreak on 500 characters
"set lbr
set tw=80

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set wrapmargin=0
set textwidth=0

" Whitespace
set formatoptions=cqt
set noshiftround

" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set to auto read when a file is changed from the outside
set autoread

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
" Remember info about open buffers on close
set viminfo^=%

" => Editing mappings
" ===============================================================
" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" map increment/decrement to Alt as C-a is my tmux leader key
nnoremap <C-i> <C-a>

" Fast saving
nmap <leader>w :w!<cr>

" Remap VIM 0 to first non-blank character
"map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h e ~/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

"press // to search for text highlighted in visual mode
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>

" => Parenthesis/bracket
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i


" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction
" for searching on a visual selection
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction
" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction
"copy matches only to buffer with CopyMatches <buffer>
function! CopyMatches(reg)
    let hits = []
    %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
    let reg = empty(a:reg) ? '+' : a:reg
    execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" => Plugin options
" ===============================================
" launch pathogen
execute pathogen#infect()

" Enable filetype plugins
filetype plugin on
filetype indent on

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

" => Status line and Airline
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %l,%c\ \ %{HasPaste()}%F%m%r%h\ %w "CWD:\ %r%{getcwd()}%h\ \
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:airline_theme="wal"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts=1

" => Goyo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <silent> <leader>z :Goyo<cr>


" => Custom header
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Startify plugin
let g:startify_custom_header = [
      \ '                                             ',
      \ '       ___________________________           ',
      \ '      /                           \          ',
      \ '      |     VIM - Vi IMproved     |          ',
      \ '      |    -------------------    |          ',
      \ '      |  by Bram Moolenaar et al. |          ',
      \ '      \_________   _______________/          ',
      \ '                \  /                         ',
      \ '                 \ \ ___                    ',
      \ '                    (-_-)                    ',
      \ '                    _) (_                    ',
      \ '                   /     \                   ',
      \ '                 _( \_ _/ )_                 ',
      \ '                (_____\_____)                ',
      \ '                                             ',
      \ ]
"
