vim.cmd([[
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath=&runtimepath
	source $HOME/.vimrc
]])
vim.g.maplocalleader = ";"
vim.g.rout_follow_colorscheme = true
-- vim.o.foldmethod = "syntax"
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
require("config.lazy")
