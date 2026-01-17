return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local langs = { "markdown", "markdown_inline", "r", "rnoweb", "yaml", "latex", "csv" }
        require("nvim-treesitter").install(langs)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = langs,
            callback = function()
                vim.treesitter.start()
            end,
        })
    end,
}
