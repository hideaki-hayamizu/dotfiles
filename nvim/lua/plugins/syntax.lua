return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function ()
    require("nvim-treesitter").install({
      -- requirements
      "regex", "bash", "lua", "vim", "markdown", "markdown_inline",
      -- user
      "asm", "c", "cmake", "comment", "cpp", "css", "csv", "diff", "disassembly", "dockerfile",
      "git_config", "git_rebase", "gitattributes", "gitignore", "glsl", "hlsl", "html", "java", "javadoc",
      "javascript", "jsdoc", "json", "luadoc", "latex", "llvm", "make", "powershell", "python", "ron",
      "rust", "sql", "ssh_config", "typescript", "toml", "vimdoc", "wgsl", "yaml", "zsh"
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if vim.api.nvim_buf_line_count(args.buf) <= 50000 then
          pcall(vim.treesitter.start, args.buf)
        end
      end,
    })
  end
}
