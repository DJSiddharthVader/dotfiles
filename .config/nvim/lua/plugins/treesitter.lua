return {
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        foldmethod = "expr",
        foldexpr = "nvim_treesitter#foldexpr()",
        config = function ()
            require("nvim-treesitter.configs").setup({
            ensure_installed = { "markdown", "markdown_inline", "r", "rnoweb", "yaml" },
            highlight = { enable = true },
            })
        end,
    }
}
