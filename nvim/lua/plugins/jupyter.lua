return {
  "sunbluesome/callisto.nvim",
  lazy = false,
  opts = {
    tmpdir = nil,
    sync = false,
    venv = ".venvs/nvim/Scripts",
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