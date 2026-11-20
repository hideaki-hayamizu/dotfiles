local jdtls = require("jdtls")
local mason_pkgs = vim.fn.stdpath("data") .. "/mason/packages"

local bundles = vim.split(
  vim.fn.glob(mason_pkgs .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
  "\n",
  { trimempty = true }
)
local root_dir = vim.fs.root(0, { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git" }) or vim.fn.getcwd()
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fs.basename(root_dir) .. "-" .. vim.fn.sha256(root_dir):sub(1, 8)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, "blink.cmp")
if ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

jdtls.start_or_attach({
  name = "jdtls",
  cmd = { "jdtls", "-data", workspace_dir },
  root_dir = root_dir,
  capabilities = capabilities,
  init_options = { bundles = bundles },
  on_attach = function(_, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = "Java: " .. desc })
    end
    map("<leader>jo", jdtls.organize_imports, "Organize imports")
    map("<leader>jt", jdtls.test_class, "Test class")
    map("<leader>jn", jdtls.test_nearest_method, "Test nearest method")
  end,
  settings = {
    java = {
      configuration = { updateBuildConfiguration = "interactive" },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      references = { includeDecompiledSources = true },
      referencesCodeLens = { enabled = true },
      implementationsCodeLens = { enabled = true },
      signatureHelp = { enabled = true, description = { enabled = true } },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
        },
        importOrder = { "java", "javax", "org", "com", "" },
        filteredTypes = { "com.sun.*", "io.micrometer.shaded.*", "java.awt.*", "jdk.*", "sun.*" },
      },
      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
      format = { enabled = false },
      inlayHints = { parameterNames = { enabled = "literals" } },
    },
  },
})