return {
  "R-nvim/R.nvim",
  lazy = false,
  opts = {
    auto_start = "on startup",
    auto_quit = true,
    config_tmux = false,
    editing_mode = "vi",
    close_term = false,
    rconsole_height = 25,
    pipe_version = 'magrittr',
    -- rmarkdown_args = "output_format=rmdformats::downcute(downcute_theme='chaos', code_folding='hide', df_print='paged', self_contained=TRUE, lightbox=TRUE, gallery=TRUE, toc_depth=5, thumbnails=FALSE)",
    rmarkdown_args = "output_file=NULL,output_dir=NULL,output_format=rmdformats::html_clean(code_folding='hide', df_print='paged', self_contained=TRUE, lightbox=TRUE, gallery=TRUE, toc_depth=5, thumbnails=FALSE)",
    -- rmarkdown_args = "output_file=NULL,output_dir=NULL,output_format=pdf_document(toc=TRUE)",
    -- Create a table with the options to be passed to setup()
    R_args = { "--quiet", "--no-save" },
    hook = {
      on_filetype = function()
        -- This function will be called at the FileType event
        -- of files supported by R.nvim. This is an
        -- opportunity to create mappings local to buffers.
        vim.keymap.set("n", "<Space>", "<Plug>RDSendLine", { buffer = true })
        vim.keymap.set("v", "<Space>", "<Plug>RSendSelection", { buffer = true })
        vim.keymap.set("v", "<LocalLeader>f", "<Plug>RFormat", { buffer = true })
        vim.keymap.set("i", "<LocalLeader>a", "<Plug>RInsertAssign", { buffer = true })
        vim.keymap.set("i", "<LocalLeader>w", "<Plug>RInsertPipe", { buffer = true })
        vim.keymap.set("i", "<LocalLeader>w", "<Plug>RInsertPipe", { buffer = true })
        vim.keymap.set("i", "<LocalLeader>c", "<Plug>RmdInsertChunk", { buffer = true })

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
    vim.g.rout_follow_colorscheme = false
    require("r").setup(opts)
    require("r.pdf.generic").open = vim.ui.open
  end,
}
