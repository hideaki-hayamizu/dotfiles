return {
  "sunbluesome/callisto.nvim",
  init = function()
    local venv = (vim.env.HOME or vim.env.USERPROFILE) .. "/.venvs/nvim/Scripts"
    vim.env.PATH = venv .. ";" .. vim.env.PATH
  end,
  opts = {
    tmpdir = nil,
    sync = false,
    venv = nil,
    run = {
      auto_export = false
    },
    watcher = {
      debounce_ms = 200,
      restart_delay_ms = 300,
    },
    keys = {
      run = "<leader>nr",
      export = nil
    }
  }
}