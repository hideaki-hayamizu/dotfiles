return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs_staged_enable = true,
      signcolumn = true,
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = true,
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      on_attach = function(bufnr)
        -- no mappings
      end,
    }
  }
}