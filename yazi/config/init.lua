require("mime-ext.local"):setup { fallback_file1 = false }
require("no-status"):setup()
require("git"):setup({
  order = 1500,
})