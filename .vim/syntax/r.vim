" Vim syntax file
" Language:	R (GNU S)
" Maintainer:	Vaidotas Zemlys <zemlys@gmail.com>
" Maintainer Candidate:	Zhuojun Chen <uifiddle@gmail.com>
" Last Change:  2010 Feb 23
" Filenames:	*.R *.Rout *.r *.Rhistory *.Rt *.Rout.save *.Rout.fail
" URL:          http://opy.me/vim/syntax/r.vim  
" First maintainer Tom Payne <tom@tompayne.org>
"
" Please download most recent version first before mailing
" any comments.
" The following parameters are available for tuning the
" R syntax highlighting, with defaults given:
"
" let g:r_base_only=1
" ---------------------------------------------------------------------
"  Load Once: {{{1
" For vim-version 5.x: Clear all syntax items
" For vim-version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if version >= 600
  setlocal iskeyword=@,48-57,_,.
else
  set iskeyword=@,48-57,_,.
endif

" ---------------------------------------------------------------------
"  Clusters: {{{1
" syn cluster			rPackageCluster         contains=/rPackage\w*/ 

" ---------------------------------------------------------------------
"  Comment: {{{1
syn match   rComment /\#.*/

" ---------------------------------------------------------------------
"  Constant: {{{1
" string enclosed in double quotes
syn region  rString start=/"/ skip=/\\\\\|\\"/ end=/"/
" string enclosed in single quotes
syn region  rString start=/'/ skip=/\\\\\|\\'/ end=/'/
" number with no fractional part or exponent
syn match   rNumber /\d\+/
" floating point number with integer and fractional parts and optional exponent
syn match   rFloat /\d\+\.\d*\([Ee][-+]\=\d\+\)\=/
" floating point number with no integer part and optional exponent
syn match   rFloat /\.\d\+\([Ee][-+]\=\d\+\)\=/
" floating point number with no fractional part and optional exponent
syn match   rFloat /\d\+[Ee][-+]\=\d\+/
syn keyword rBuiltInConstant LETTERS letters month.abb pi
syn keyword rConstant NULL
syn keyword rBoolean  FALSE TRUE
syn keyword rNumber   NA

" ---------------------------------------------------------------------
"  Identifier: {{{1
" identifier with leading letter and optional following keyword characters
syn match    rNormal /\a\k*/
" identifier with leading period, one or more digits, and at least one non-digit keyword character
syn match    rNormal /\.\d*\K\k*/
" function
syn match    rFunction /\<as\.array\>/
syn match    rFunction /\<as\.call\>/
syn match    rFunction /\<as\.complex\>/
syn match    rFunction /\<as\.Date\>/
syn match    rFunction /\<as\.difftime\>/
syn match    rFunction /\<as\.environment\>/
syn match    rFunction /\<as\.expression\>/
syn match    rFunction /\<as\.factor\>/
syn match    rFunction /\<as\.function\>/
syn match    rFunction /\<as\.hexmode\>/
syn match    rFunction /\<as\.integer\>/
syn match    rFunction /\<as\.logical\>/
syn match    rFunction /\<as\.name\>/
syn match    rFunction /\<as\.null\>/
syn match    rFunction /\<as\.numeric\>/
syn match    rFunction /\<as\.numeric_version\>/
syn match    rFunction /\<as\.octmode\>/
syn match    rFunction /\<as\.ordered\>/
syn match    rFunction /\<as\.package_version\>/
syn match    rFunction /\<as\.pairlist\>/
syn match    rFunction /\<as\.POSIXct\>/
syn match    rFunction /\<as\.POSIXlt\>/
syn match    rFunction /\<as\.qr\>/
syn match    rFunction /\<as\.raw\>/
syn match    rFunction /\<as\.real\>/
syn match    rFunction /\<as\.single\>/
syn match    rFunction /\<as\.symbol\>/
syn match    rFunction /\<as\.table\>/
syn match    rFunction /\<as\.vector\>/
syn region   rNormal matchgroup=rFunction start=/\<abbreviate(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<abs(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<acos(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<acosh(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<addNA(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<agrep(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<alist(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<asin(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<asinh(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<atan(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<atan2(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<atanh(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/\<[dpqr]\(unif\|binom\|cauchy\|chisq\|exp\|f\|gamma\|geom\|hyper\|logis\|lnorm\|nbinom\|norm\|pois\|signrank\|t\|unif\|weibull\|wilcox\)(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/[dr]multinom(/ end=/)/ contains=ALL
syn region   rNormal matchgroup=rFunction start=/[pq]tukey(/ end=/)/ transparent contains=ALL
syn keyword  rParameter x q p n m nn k size prob mean min max lower.tail log.p log sd location scale df ncp rate df1 df2 shape meanlog sdlog lambda contained
syn keyword  rFunction abs acos acosh addNA agrep alist asin asinh atan atan2 atanh
syn keyword  rFunction numeric_version package_version R_system_version getRversion



" ---------------------------------------------------------------------
"  Statement: {{{1
syn keyword rStatement   break next return
syn keyword rConditional if else
syn keyword rRepeat      for in repeat while
syn match   rOperator    /[\*\!\$\%\&\+\-\<\>\=\^\|\~\`/:@]/
syn match   rOperator    /%o%\|%x%\|xor\|isTRUE/

" ---------------------------------------------------------------------
"  PreProc: {{{1
syn region rNormal matchgroup=rPreProc start=/library(/ end=/)/ contains=ALL
syn region rNormal matchgroup=rPreProc start=/require(/ end=/)/ contains=ALL
if !exists("g:r_base_only")
endif

" ---------------------------------------------------------------------
"  Type: {{{1
syn keyword rType symbol pairlist closure environment promise language special builtin char logical integer double complex character ... any expression list bytecode externalptr weakref raw S4

" ---------------------------------------------------------------------
"  Special: {{{1
syn match rDelimiter /[,;]/

" ---------------------------------------------------------------------
"  Error: {{{1
syn region rRegion matchgroup=Delimiter start=/(/ matchgroup=Delimiter end=/)/ transparent contains=ALLBUT,rError,rBraceError,rCurlyError
syn region rRegion matchgroup=Delimiter start=/{/ matchgroup=Delimiter end=/}/ transparent contains=ALLBUT,rError,rBraceError,rParenError
syn region rRegion matchgroup=Delimiter start=/\[/ matchgroup=Delimiter end=/]/ transparent contains=ALLBUT,rError,rCurlyError,rParenError
syn match rError      /[)\]}]/
syn match rBraceError /[)}]/ contained
syn match rCurlyError /[)\]]/ contained
syn match rParenError /[\]}]/ contained

" ---------------------------------------------------------------------
"  Define The Default Highlighting: {{{1
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_r_syn_inits")
  if version < 508
    let did_r_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink rNormal		        Normal
  HiLink rComment		        Comment
  HiLink rBuiltInConstant               Constant
  HiLink rString         		String
  HiLink rNumber         		Number
  HiLink rBoolean        		Boolean
  HiLink rFloat          		Float
  "HiLink rHeuristic			PreProc
  HiLink rFunction       		Function
  HiLink rStatement      		Statement
  HiLink rPackageRODBC        		Statement
  HiLink rPackageRODBC2       		Function
  HiLink rPackageChron        		Statement
  HiLink rPackagerjson        		Statement
  HiLink rConditional    		Conditional
  HiLink rRepeat         		Repeat
  HiLink rIdentifier     		Identifier
  HiLink rOperator       		Operator
  HiLink rConstant       		Constant
  HiLink rParameter       		Statement
  HiLink rArithmeticOperator	        Operator
  HiLink rRelationalOperator	        Operator
  HiLink rAssignmentOperator	        Operator
  HiLink rLogicalOperator		Operator
  HiLink rType           		Type
  HiLink rDelimiter      		Delimiter
  HiLink rError          		Error
  HiLink rBraceError     		Error
  HiLink rCurlyError     		Error
  HiLink rParenError     		Error
  HiLink rPreProc        		PreProc
  delcommand HiLink
endif

let b:current_syntax="r"

" ---------------------------------------------------------------------
" vim: ts=8 fdm=marker
" Add R.nvim stuff {{{1
" Vim syntax file
" Language:    R output Files
" Maintainer:  Jakson Aquino <jalvesaq@gmail.com>


if exists("b:current_syntax")
    finish
endif

setlocal iskeyword=@,48-57,_,.

syn case match

" Normal text
syn match routNormal "."

" Strings
syn region routString start=/"/ skip=/\\\\\|\\"/ end=/"/ end=/$/

" Constants
syn keyword routConst  NULL NA NaN
syn keyword routTrue   TRUE
syn keyword routFalse  FALSE
syn match routConst "\<Na's\>"
syn match routInf "-Inf\>"
syn match routInf "\<Inf\>"

" integer
syn match routInteger "\<\d\+L"
syn match routInteger "\<0x\([0-9]\|[a-f]\|[A-F]\)\+L"
syn match routInteger "\<\d\+[Ee]+\=\d\+L"

" number with no fractional part or exponent
syn match routNumber "\<\d\+\>"
syn match routNegNum "-\<\d\+\>"
" hexadecimal number
syn match routNumber "\<0x\([0-9]\|[a-f]\|[A-F]\)\+"

let g:R_OutDec = get(g:, "R_OutDec", ".")

if g:R_OutDec == ","
    syn match routFloat "\<\d\+,\d*\([Ee][-+]\=\d\+\)\="
    syn match routNegFloat "-\<\d\+,\d*\([Ee][-+]\=\d\+\)\="
    syn match routFloat "\<,\d\+\([Ee][-+]\=\d\+\)\="
    syn match routNegFloat "-\<,\d\+\([Ee][-+]\=\d\+\)\="
    syn match routFloat "\<\d\+[Ee][-+]\=\d\+"
    syn match routNegFloat "-\<\d\+[Ee][-+]\=\d\+"
    syn match routComplex "\<\d\+i"
    syn match routComplex "\<\d\++\d\+i"
    syn match routComplex "\<0x\([0-9]\|[a-f]\|[A-F]\)\+i"
    syn match routComplex "\<\d\+,\d*\([Ee][-+]\=\d\+\)\=i"
    syn match routComplex "\<,\d\+\([Ee][-+]\=\d\+\)\=i"
    syn match routComplex "\<\d\+[Ee][-+]\=\d\+i"
else
    " floating point number with integer and fractional parts and optional exponent
    syn match routFloat "\<\d\+\.\d*\([Ee][-+]\=\d\+\)\="
    syn match routNegFloat "-\<\d\+\.\d*\([Ee][-+]\=\d\+\)\="
    " floating point number with no integer part and optional exponent
    syn match routFloat "\<\.\d\+\([Ee][-+]\=\d\+\)\="
    syn match routNegFloat "-\<\.\d\+\([Ee][-+]\=\d\+\)\="
    " floating point number with no fractional part and optional exponent
    syn match routFloat "\<\d\+[Ee][-+]\=\d\+"
    syn match routNegFloat "-\<\d\+[Ee][-+]\=\d\+"
    " complex number
    syn match routComplex "\<\d\+i"
    syn match routComplex "\<\d\++\d\+i"
    syn match routComplex "\<0x\([0-9]\|[a-f]\|[A-F]\)\+i"
    syn match routComplex "\<\d\+\.\d*\([Ee][-+]\=\d\+\)\=i"
    syn match routComplex "\<\.\d\+\([Ee][-+]\=\d\+\)\=i"
    syn match routComplex "\<\d\+[Ee][-+]\=\d\+i"
endif


" dates and times
syn match routDate "[0-9][0-9][0-9][0-9][-/][0-9][0-9][-/][0-9][-0-9]"
syn match routDate "[0-9][0-9][-/][0-9][0-9][-/][0-9][0-9][0-9][-0-9]"
syn match routDate "[0-9][0-9]:[0-9][0-9]:[0-9][-0-9]"

if !exists("g:Rout_more_colors")
    let g:Rout_more_colors = 0
endif

let g:Rout_prompt_str = get(g:, 'Rout_prompt_str', '>')
let g:Rout_continue_str = get(g:, 'Rout_continue_str', '+')

if g:Rout_more_colors
    syn include @routR syntax/r.vim
    exe 'syn region routColoredR start=/^' . g:Rout_prompt_str . '/ end=/$/ contains=@routR keepend'
    exe 'syn region routColoredR start=/^' . g:Rout_continue_str . '/ end=/$/ contains=@routR keepend'
else
    " Input
    exe 'syn match routInput /^' . g:Rout_prompt_str . '.*/'
    exe 'syn match routInput /^' . g:Rout_continue_str . '.*/'
endif

" Index of vectors
syn match routIndex /^\s*\[\d\+\]/

" Errors and warnings
syn match routError "^Error.*"
syn match routWarn "^Warning.*"

if v:lang =~ "^da"
    syn match routError	"^Fejl.*"
    syn match routWarn	"^Advarsel.*"
endif

if v:lang =~ "^de"
    syn match routError	"^Fehler.*"
    syn match routWarn	"^Warnung.*"
endif

if v:lang =~ "^es"
    syn match routWarn	"^Aviso.*"
endif

if v:lang =~ "^fr"
    syn match routError	"^Erreur.*"
    syn match routWarn	"^Avis.*"
endif

if v:lang =~ "^it"
    syn match routError	"^Errore.*"
    syn match routWarn	"^Avviso.*"
endif

if v:lang =~ "^nn"
    syn match routError	"^Feil.*"
    syn match routWarn	"^Åtvaring.*"
endif

if v:lang =~ "^pl"
    syn match routError	"^BŁĄD.*"
    syn match routError	"^Błąd.*"
    syn match routWarn	"^Ostrzeżenie.*"
endif

if v:lang =~ "^pt_BR"
    syn match routError	"^Erro.*"
    syn match routWarn	"^Aviso.*"
endif

if v:lang =~ "^ru"
    syn match routError	"^Ошибка.*"
    syn match routWarn	"^Предупреждение.*"
endif

if v:lang =~ "^tr"
    syn match routError	"^Hata.*"
    syn match routWarn	"^Uyarı.*"
endif

" Define the default highlighting.
if g:Rout_more_colors == 0
    hi def link routInput	Comment
endif

if exists("g:rout_follow_colorscheme") && g:rout_follow_colorscheme
    " Default when following :colorscheme
    hi def link routNormal	Normal
    hi def link routNumber	Number
    hi def link routInteger	Number
    hi def link routFloat	Float
    hi def link routComplex	Number
    hi def link routNegNum	Number
    hi def link routNegFloat	Float
    hi def link routDate	Number
    hi def link routTrue	Boolean
    hi def link routFalse	Boolean
    hi def link routInf  	Number
    hi def link routConst	Constant
    hi def link routString	String
    hi def link routIndex	Special
    hi def link routError	ErrorMsg
    hi def link routWarn	WarningMsg
else
    function s:SetGroupColor(group, cgui, c256, c16)
        if exists("g:rout_color_" . tolower(a:group))
            exe "hi rout" . a:group . eval("g:rout_color_" . tolower(a:group))
        elseif &t_Co == 256
            exe "hi rout" . a:group . "ctermfg=" . a:c256 . " guifg=" . a:cgui
        else
            exe "hi rout" . a:group . "ctermfg=" . a:c16 . " guifg=" . a:cgui
        endif
    endfunction
    call s:SetGroupColor("Input ",    "#9e9e9e",               "247",          "gray")
    call s:SetGroupColor("Normal ",   "#00d700",               "40",           "darkgreen")
    call s:SetGroupColor("Number ",   "#ffaf00",               "214",          "darkyellow")
    call s:SetGroupColor("Integer ",  "#ffaf00",               "214",          "darkyellow")
    call s:SetGroupColor("Float ",    "#ffaf00",               "214",          "darkyellow")
    call s:SetGroupColor("Complex ",  "#ffaf00",               "214",          "darkyellow")
    call s:SetGroupColor("NegNum ",   "#ff875f",               "209",          "darkyellow")
    call s:SetGroupColor("NegFloat ", "#ff875f",               "209",          "darkyellow")
    call s:SetGroupColor("Date ",     "#d7af5f",               "179",          "darkyellow")
    call s:SetGroupColor("False ",    "#ff5f5f",               "203",          "darkyellow")
    call s:SetGroupColor("True ",     "#5fd787",               "78",           "magenta")
    call s:SetGroupColor("Inf ",      "#00afff",               "39",           "darkgreen")
    call s:SetGroupColor("Const ",    "#00af5f",               "35",           "magenta")
    call s:SetGroupColor("String ",   "#5fffaf",               "85",           "darkcyan")
    call s:SetGroupColor("Error ",    "#ffffff guibg=#c00000", "15 ctermbg=1", "white ctermbg=red")
    call s:SetGroupColor("Warn ",     "#c00000",               "1",            "red")
    call s:SetGroupColor("Index ",    "#87afaf",               "109",          "darkgreen")
    delfunction s:SetGroupColor
endif

let   b:current_syntax = "rout"

" vim: ts=8 sw=4
