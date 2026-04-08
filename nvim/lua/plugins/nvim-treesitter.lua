local ft = {
  -- {filetype, parser}
  { 'gitconfig', 'git_config'},
  { 'gitrebase', 'git_rebase'},
  { 'ps1', 'powershell'},
}

local langs = {
  'bash', 'c', 'cmake', 'cpp', 'css', 'csv', 'diff', 'dockerfile', 'fish',
  'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'glsl',
  'html', 'javascript', 'json', 'lua', 'make', 'markdown', 'markdown_inline',
  'meson', 'ninja', 'powershell', 'python', 'regex', 'rust', 'sql', 'toml', 'typescript',
  'vim', 'wgsl', 'yaml', 'zsh'
}

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  init = function()
    if vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
      vim.env.CC = 'gcc'
    end
  end,
  config = function()
    local treesitter = require('nvim-treesitter')
    treesitter.setup()
    treesitter.install(langs)

    for _, v in ipairs(ft) do
      vim.treesitter.language.register( v[1], { v[2] })
    end

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end

        local parser = vim.treesitter.get_parser(args.buf, lang)
        if not parser then
          return
        end

        vim.treesitter.start(args.buf, lang)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
}