return {
    'vim-airline/vim-airline',
    init = function()
        vim.cmd([[
            set laststatus=2
            set statusline=\ %l,%c\ \ %{HasPaste()}%F%m%r%h\ %w "CWD:\ %r%{getcwd()}%h\ \
            set statusline+=%#warningmsg#
            set statusline+=%{SyntasticStatuslineFlag()}
            set statusline+=%*
            let g:airline_theme="wal"
            "let g:airline_theme="molokai"
            "let g:airline_theme="base16_gruvbox_dark_hard"
            let g:airline#extensions#tabline#enabled = 1
            let g:airline#extensions#tabline#fnamemod = ':t'
            let g:airline#extensions#tabline#show_buffers = 1
            let g:airline_stl_path_style = 'short'
            let g:airline#extensions#tabline#left_sep = ''
            let g:airline#extensions#tabline#left_alt_sep = ''
            let g:airline_powerline_fonts=1
        ]])
    end
}
