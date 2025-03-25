return {
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        opts = {
            require("nvim-treesitter.configs").setup({
                -- ensure_installed = {
                --     "markdown",
                --     "markdown_inline",
                --     "r",
                --     "bash",
                --     "python",
                --     "rnoweb",
                --     "yaml"
                -- },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { 'markdown' },
                },
                folding = { 
                    -- disable = { "R" },
                    enable = true
                },
                indent = { 
                    enable = true 
                    -- enable = false
                },
            })
        },
        config = function (_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end,
    }
}
