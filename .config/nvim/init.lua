vim.cmd([[
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
	let &packpath=&runtimepath
    " automatically saves & loads folds when closing or opening a file
    set viewoptions-=options
    augroup remember_folds
        autocmd!
        autocmd BufWinLeave *.* mkview
        autocmd BufWinEnter *.* silent! loadview
    augroup END
    " au BufRead * :loadview
    au BufRead * normal zM
	source $HOME/.vimrc
]])
vim.g.maplocalleader = ";"
vim.g.rout_follow_colorscheme = true
require("config.lazy")
-- highlighting
vim.treesitter.start()
vim.api.nvim_create_autocmd('FileType', {
    pattern = { '<filetype>' },
    callback = function() vim.treesitter.start() end,
})
-- folding
vim.wo[0][0].foldmethod = 'expr'
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- indent
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
