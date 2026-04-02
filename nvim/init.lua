local minor_version = vim.version().minor
if minor_version < 12 then
  vim.api.nvim_echo({
    {
      "Use version 0.12.0 or later\n",
      "ErrorMsg",
    },
    { "Press any key to exit", "MoreMsg" },
  }, true, {})

  vim.fn.getchar()
  vim.cmd([[quit]])
end

if vim.loader then
  vim.loader.enable()
end

require('config.lazy')
