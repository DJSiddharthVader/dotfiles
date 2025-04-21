return {
  "R-nvim/R.nvim",
  lazy = false,
  opts = {
    config_tmux = false,
    close_term = false,
    pipe_version = 'magrittr',
    -- Create a table with the options to be passed to setup()
    R_args = { "--quiet", "--no-save" },
    hook = {
      on_filetype = function()
        -- This function will be called at the FileType event
        -- of files supported by R.nvim. This is an
        -- opportunity to create mappings local to buffers.
        vim.keymap.set("n", "<Space>", "<Plug>RDSendLine", { buffer = true })
        vim.keymap.set("v", "<Space>", "<Plug>RSendSelection", { buffer = true })
        vim.keymap.set("v", "<localleader>l", "<Plug>RFormat", { buffer = true })
        vim.keymap.set("i", "<localleader>a", "<Plug>RInsertAssign", { buffer = true })
        vim.keymap.set("i", "<localleader>w", "<Plug>RInsertPipe", { buffer = true })
        local wk = require("which-key")
        wk.add({
          buffer = true,
          mode = { "n", "v" },
          { "<localleader>b", group = "between marks" },
          { "<localleader>c", group = "chunks" },
          { "<localleader>f", group = "functions" },
          { "<localleader>g", group = "goto" },
          { "<localleader>i", group = "install" },
          { "<localleader>k", group = "knit" },
          { "<localleader>p", group = "paragraph" },
          { "<localleader>q", group = "quarto" },
          { "<localleader>r", group = "r general" },
          { "<localleader>s", group = "split or send" },
          { "<localleader>t", group = "terminal" },
          { "<localleader>v", group = "view" },
        })
      end,
    },
    pdfviewer = "",
  },
  config = function(_, opts)
    require("r").setup(opts)
    require("r.pdf.generic").open = vim.ui.open
  end,
}
