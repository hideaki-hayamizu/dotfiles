return {
  "delphinus/md-render.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "delphinus/budoux.lua"
  },
  keys = {
    {
      "<leader>pm",
      "<cmd>MdRender toggle<CR>",
      desc = "Markdown preview (toggle)"
    },
  },
  config = function ()
    require("md-render.text_size").setup { enabled = false }
  end
}