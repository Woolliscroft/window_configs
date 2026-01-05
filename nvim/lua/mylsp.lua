local caps = vim.lsp.protocol.make_client_capabilities()
caps = require("cmp_nvim_lsp").default_capabilities(caps)

local function on_attach(_, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

-- clangd
vim.lsp.config("clangd", {
  capabilities = caps,
  on_attach = on_attach,
})

-- lua
vim.lsp.config("lua_ls", {
  capabilities = caps,
  on_attach = on_attach,
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } },
  },
})

vim.lsp.enable({ "clangd", "lua_ls" })

