return {
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function ()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { 
                    "markdown", "markdown_inline", "r", "rnoweb", "yaml" 
                },
                highlight = { 
                    enable = true,
                    additional_vim_regex_highlighting = true,
                },
                indent = {
                    enable = true
                },
                folding = {
                    enable = true
                },
            })
        end,
    }
}
