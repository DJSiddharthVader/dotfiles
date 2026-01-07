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
local highlight = {
    "angr1",
    "angr2",
    "angr3",
    "angr4",
    "angr5",
    "angr6",
    "angr7",
}
local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "angr1", { fg = "#82c057" })
    vim.api.nvim_set_hl(0, "angr2", { fg = "#87afdf" })
    vim.api.nvim_set_hl(0, "angr3", { fg = "#87dfaf" })
    vim.api.nvim_set_hl(0, "angr4", { fg = "#87dfdf" })
    vim.api.nvim_set_hl(0, "angr5", { fg = "#95d5f1" })
    vim.api.nvim_set_hl(0, "angr6", { fg = "#9d7ff2" })
    vim.api.nvim_set_hl(0, "angr7", { fg = "#af97df" })
end)
require("ibl").setup()
