vim.cmd([[
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath=&runtimepath
	source $HOME/.vimrc
]])
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter.foldexpr()"
require("config.lazy")
