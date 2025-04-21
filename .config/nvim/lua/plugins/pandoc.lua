return {
    'aspeddro/pandoc.nvim',
    enabled = false, 
    config = function()
        require'pandoc'.setup()
    end
}
