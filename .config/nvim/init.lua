vim.cmd([[
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath=&runtimepath
	source $HOME/.vimrc
    set spell spelllang=en_us
    autocmd VimEnter * execute "normal zX"
]])
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
require("config.lazy")
