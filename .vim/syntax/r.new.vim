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
let b:current_syntax="r"
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

syn case match

" ---------------------------------------------------------------------
"  Comment: {{{1
syn match   rComment /\#.*/

" ---------------------------------------------------------------------
"  Constant: {{{1
" string enclosed in double quotes
syn region  rString start=/"/ skip=/\\\\\|\\"/ end=/"/
syn region  rString start=/'/ skip=/\\\\\|\\'/ end=/'/
" syn region rString start=/"/ skip=/\\\\\|\\"/ end=/"/ end=/$/
" number with no fractional part or exponent
syn match   rNumber /\d\+/
syn keyword rNumber   NA
syn match rNumber "\<\d\+\>"
syn match rNegNum "-\<\d\+\>"
syn match rNumber "\<0x\([0-9]\|[a-f]\|[A-F]\)\+"
" syn match rInteger "\<\d\+L"
syn match rInteger "\<0x\([0-9]\|[a-f]\|[A-F]\)\+L"
syn match rInteger "\<\d\+[Ee]+\=\d\+L"


" identifier with leading letter and optional following keyword characters
syn match    rNormal /\a\k*/
" identifier with leading period, one or more digits, and at least one non-digit keyword character
syn match    rNormal /\.\d*\K\k*/

" Constants
syn keyword rBuiltInConstant LETTERS letters month.abb pi
syn keyword rConstant NULL
syn match rConst "\<Na's\>"
syn keyword rConst  NULL NA NaN

syn keyword rBoolean  FALSE TRUE
syn keyword rTrue   TRUE
syn keyword rFalse  FALSE

syn match rInf "-Inf\>"
syn match rInf "\<Inf\>"

" floating point number with integer and fractional parts and optional exponent
syn match   rFloat /\d\+\.\d*\([Ee][-+]\=\d\+\)\=/
syn match   rFloat /\.\d\+\([Ee][-+]\=\d\+\)\=/
syn match   rFloat /\d\+[Ee][-+]\=\d\+/
let g:R_OutDec = get(g:, "R_OutDec", ".")
if g:R_OutDec == ","
    syn match rFloat "\<\d\+,\d*\([Ee][-+]\=\d\+\)\="
    syn match rNegFloat "-\<\d\+,\d*\([Ee][-+]\=\d\+\)\="
    syn match rFloat "\<,\d\+\([Ee][-+]\=\d\+\)\="
    syn match rNegFloat "-\<,\d\+\([Ee][-+]\=\d\+\)\="
    syn match rFloat "\<\d\+[Ee][-+]\=\d\+"
    syn match rNegFloat "-\<\d\+[Ee][-+]\=\d\+"
    syn match rComplex "\<\d\+i"
    syn match rComplex "\<\d\++\d\+i"
    syn match rComplex "\<0x\([0-9]\|[a-f]\|[A-F]\)\+i"
    syn match rComplex "\<\d\+,\d*\([Ee][-+]\=\d\+\)\=i"
    syn match rComplex "\<,\d\+\([Ee][-+]\=\d\+\)\=i"
    syn match rComplex "\<\d\+[Ee][-+]\=\d\+i"
else
    " floating point number with integer and fractional parts and optional exponent
    syn match rFloat "\<\d\+\.\d*\([Ee][-+]\=\d\+\)\="
    syn match rNegFloat "-\<\d\+\.\d*\([Ee][-+]\=\d\+\)\="
    " floating point number with no integer part and optional exponent
    syn match rFloat "\<\.\d\+\([Ee][-+]\=\d\+\)\="
    syn match rNegFloat "-\<\.\d\+\([Ee][-+]\=\d\+\)\="
    " floating point number with no fractional part and optional exponent
    syn match rFloat "\<\d\+[Ee][-+]\=\d\+"
    syn match rNegFloat "-\<\d\+[Ee][-+]\=\d\+"
    " complex number
    syn match rComplex "\<\d\+i"
    syn match rComplex "\<\d\++\d\+i"
    syn match rComplex "\<0x\([0-9]\|[a-f]\|[A-F]\)\+i"
    syn match rComplex "\<\d\+\.\d*\([Ee][-+]\=\d\+\)\=i"
    syn match rComplex "\<\.\d\+\([Ee][-+]\=\d\+\)\=i"
    syn match rComplex "\<\d\+[Ee][-+]\=\d\+i"
endif


" dates and times
syn match rDate "[0-9][0-9][0-9][0-9][-/][0-9][0-9][-/][0-9][-0-9]"
syn match rDate "[0-9][0-9][-/][0-9][0-9][-/][0-9][0-9][0-9][-0-9]"
syn match rDate "[0-9][0-9]:[0-9][0-9]:[0-9][-0-9]"

" Index of vectors
syn match rIndex /^\s*\[\d\+\]/

" Errors and warnings
syn match rError "^Error.*"
syn match rWarn "^Warning.*"

" ---------------------------------------------------------------------
"  Identifier: {{{1
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
    " Default when following :colorscheme
    " hi def link rNormal     Normal
    " hi def link rNumber     Number
    hi def link rInteger    Number
    " hi def link rFloat	    Float
    hi def link rComplex    Number
    hi def link rNegNum	    Number
    hi def link rNegFloat   Float
    hi def link rDate       Number
    hi def link rTrue       Boolean
    hi def link rFalse      Boolean
    hi def link rInf        Number
    hi def link rConst      Constant
    " hi def link rString     String
    hi def link rIndex      Special
    " hi def link rError      ErrorMsg
    hi def link rWarn       WarningMsg

    hi def link rNormal		                Normal
    hi def link rComment		        Comment
    hi def link rBuiltInConstant                Constant
    hi def link rString         		String
    hi def link rNumber         		Number
    hi def link rBoolean        		Boolean
    hi def link rFloat          		Float
    hi def link rFunction       		Function
    hi def link rStatement      		Statement
    hi def link rPackageRODBC        		Statement
    hi def link rPackageRODBC2       		Function
    hi def link rPackageChron        		Statement
    hi def link rPackagerjson        		Statement
    hi def link rConditional    		Conditional
    hi def link rRepeat         		Repeat
    hi def link rIdentifier     		Identifier
    hi def link rOperator       		Operator
    hi def link rConstant       		Constant
    hi def link rParameter       		Statement
    hi def link rArithmeticOperator	        Operator
    hi def link rRelationalOperator	        Operator
    hi def link rAssignmentOperator	        Operator
    hi def link rLogicalOperator		Operator
    hi def link rType           		Type
    hi def link rDelimiter      		Delimiter
    hi def link rError          		Error
    hi def link rBraceError     		Error
    hi def link rCurlyError     		Error
    hi def link rParenError     		Error
    hi def link rPreProc        		PreProc
  delcommand HiLink
endif


" ---------------------------------------------------------------------
