vim.cmd([[
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath=&runtimepath
	source $HOME/.vimrc
    autocmd VimEnter * execute "normal zR"
    set autochdir
]])
-- vim.g.python3_host_prog = vim.fn.expand("~/miniconda3/envs/molten/bin/python3")
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.g.maplocalleader = ';'
require("config.lazy")
