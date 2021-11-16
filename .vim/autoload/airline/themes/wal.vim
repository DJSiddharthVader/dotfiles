" Author:   Danilo Augusto
" Script:   Alduin (vim-airline version)
" License:  MIT

let s:gui00 = "#0a0604"
let s:gui01 = "#9B8B6F" " ANSI Black
let s:gui02 = "#C8A978" " ANSI Red
let s:gui03 = "#747A83" " ANSI Green
let s:gui04 = "#9F9990" " ANSI Yellow
let s:gui05 = "#B4B0AB" " ANSI Blue
let s:gui06 = "#C7BDAC" " ANSI Magenta
let s:gui07 = "#e0e0df" " ANSI Cyan
let s:gui08 = "#9c9c9c" " ANSI White
let s:gui09 = "#9B8B6F"
let s:gui10 = "#C8A978"
let s:gui0A = "#747A83"
let s:gui0B = "#9F9990"
let s:gui0C = "#B4B0AB"
let s:gui0D = "#C7BDAC"
let s:gui0E = "#e0e0df"
let s:gui0F = "#e0e0df"

let s:cterm00 = "0"
let s:cterm01 = "1"
let s:cterm02 = "2"
let s:cterm03 = "3"
let s:cterm04 = "4"
let s:cterm05 = "5"
let s:cterm06 = "6"
let s:cterm07 = "7"
let s:cterm08 = "8"

let s:guiWhite = "#ffffff"
let s:guiGray = "#666666"
let s:guiDarkGray = "#545454"
let s:guiAlmostBlack = "#2a2a2a"
let s:ctermWhite = "7"
let s:ctermGray = 00"
let s:ctermDarkGray = "240"
let s:ctermAlmostBlack = "235"

let g:airline#themes#wal#palette = {}
let s:modified = { 'airline_c': [s:gui01, '', s:cterm07, '', ''] }

" Normal mode
let s:N1 = [s:guiWhite, s:gui01, s:ctermWhite, s:cterm01]
let s:N2 = [s:guiWhite, s:gui02, s:ctermWhite, s:cterm02]
let s:N3 = [s:guiWhite, s:gui03, s:ctermWhite, s:cterm03]
let g:airline#themes#wal#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#wal#palette.normal_modified = s:modified

" Insert mode
let s:I1 = [s:guiWhite, s:gui03, s:ctermWhite, s:cterm03]
let s:I2 = [s:guiWhite, s:gui04, s:ctermWhite, s:cterm04]    
let s:I3 = [s:guiWhite, s:gui05, s:ctermWhite, s:cterm05]
let g:airline#themes#wal#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#wal#palette.insert_modified = s:modified

" Visual mode
let s:V1 = [s:guiWhite, s:gui04, s:ctermWhite, s:cterm04]
let s:V2 = [s:guiWhite, s:gui05, s:ctermWhite, s:cterm05]
let s:V3 = [s:guiWhite, s:gui06, s:ctermWhite, s:cterm06]
let g:airline#themes#wal#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#wal#palette.visual_modified = s:modified

" Replace mode
let s:R1 = [s:guiWhite, s:gui0D, s:cterm08, s:cterm07]
let s:R2 = s:N2
let s:R3 = s:I3
let g:airline#themes#wal#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#wal#palette.replace_modified = s:modified

" Inactive mode
let s:IN1 = [s:guiGray, s:gui01, s:ctermGray, s:cterm01]
let s:IN2 = [s:gui04, s:guiAlmostBlack, s:cterm04, s:ctermAlmostBlack]
let s:IN3 = [s:gui05, s:guiAlmostBlack, s:cterm05, s:ctermAlmostBlack]
let g:airline#themes#wal#palette.inactive = airline#themes#generate_color_map(s:IN1, s:IN2, s:IN3)
let g:airline#themes#wal#palette.inactive_modified = s:modified

" CtrlP
if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let s:CP1 = [s:guiWhite, s:gui02, s:ctermWhite, s:cterm01]
let s:CP2 = [s:guiWhite, s:gui03, s:ctermWhite, s:cterm03]
let s:CP3 = [s:guiWhite, s:gui04, s:ctermWhite, s:cterm05]
let g:airline#themes#wal#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(
      \ s:CP1,
      \ s:CP2,
      \ s:CP3)
