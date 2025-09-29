-- ======================
-- PACKER PLUGINS
-- ======================
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'        -- Packer manages itself
  use 'windwp/nvim-autopairs'         -- Auto pairs
  use 'echasnovski/mini.nvim'         -- Mini plugins
  use 'morhetz/gruvbox'               -- Fallback theme
  use 'retrobox/vim-retrobox'         -- Retrobox theme

  -- Completion (nvim-cmp)
  use 'hrsh7th/nvim-cmp'              -- Completion engine
  use 'hrsh7th/cmp-nvim-lsp'          -- LSP source
  use 'hrsh7th/cmp-buffer'            -- Buffer words
  use 'hrsh7th/cmp-path'              -- File paths
  use 'hrsh7th/cmp-cmdline'           -- Cmdline completion
  use 'L3MON4D3/LuaSnip'              -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip'      -- Snippet source
end)

-- ======================
-- GENERAL SETTINGS
-- ======================
vim.o.number       = true
vim.o.tabstop      = 2
vim.o.shiftwidth   = 2
vim.o.smartcase    = true
vim.o.ignorecase   = true
vim.o.wrap         = false
vim.o.hlsearch     = false
vim.o.signcolumn   = 'yes'
vim.o.cindent      = true
vim.o.smartindent  = true

-- Space as leader
vim.g.mapleader = " "

-- ======================
-- KEYMAPS
-- ======================
-- Clipboard
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard text'})
-- Commands
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save file'})
vim.keymap.set('n', '<leader>q', '<cmd>quitall<cr>', {desc = 'Exit vim'})

-- ======================
-- THEME
-- ======================
vim.cmd.colorscheme('retrobox')

-- ======================
-- NVIM-AUTOPAIRS
-- ======================
require('nvim-autopairs').setup({})

-- ======================
-- FILETYPE SPECIFIC SETTINGS
-- ======================
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "java" },
  callback = function()
    vim.bo.cindent     = true
    vim.bo.smartindent = true
    vim.bo.shiftwidth  = 2
    vim.bo.tabstop     = 2
  end,
})

-- ======================
-- LSP SETUP (Neovim v0.11+)
-- ======================
local servers = {
  "luals",        -- Lua
  "clangd",       -- C/C++
  "pyright",      -- Python
  "gopls",        -- Go
  "rust_analyzer" -- Rust
}

-- Default LSP keymaps
local lsp_keymaps = function(buf)
  local opts = { buffer = buf, silent = true }
  vim.keymap.set("n", "gra", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "grr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, opts)
  vim.keymap.set("i", "<C-S>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end

-- Function to setup a server
local setup_server = function(name, config)
  config = config or {}
  config = vim.tbl_deep_extend("force", {
    on_attach = function(client, buf)
      lsp_keymaps(buf)
      vim.bo[buf].omnifunc   = "v:lua.vim.lsp.omnifunc"
      vim.bo[buf].tagfunc    = "v:lua.vim.lsp.tagfunc"
      vim.bo[buf].formatexpr = "v:lua.vim.lsp.formatexpr()"

      if client.server_capabilities.colorProvider then
        vim.lsp.document_color.enable(true, buf)
      end

      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
          end,
        })
      end
    end,
  }, config)
  vim.lsp.config[name] = config
  vim.lsp.enable(name)
end

-- Server configs
local server_configs = {
  luals = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
    settings = { Lua = { runtime = { version = "LuaJIT" } } },
  },
  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { ".clangd", "compile_commands.json", ".git" },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { ".git" },
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go" },
    root_markers = { "go.mod", ".git" },
  },
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
  },
}

-- Setup all servers
for _, server in ipairs(servers) do
  setup_server(server, server_configs[server])
end

-- ======================
-- NVIM-CMP SETUP
-- ======================
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<Tab>']     = cmp.mapping.select_next_item(),
    ['<S-Tab>']   = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  completion = {
    autocomplete = { cmp.TriggerEvent.TextChanged },
  }
})

-- Integrate LSP capabilities with nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, server in ipairs(servers) do
  server_configs[server].capabilities = capabilities
end

-- Re-setup servers with updated capabilities
for _, server in ipairs(servers) do
  setup_server(server, server_configs[server])
end

-- ======================
-- NVIM-CMP HIGHLIGHTING
-- ======================
-- Make cmp popup match retrobox theme
vim.api.nvim_set_hl(0, "CmpItemAbbr",        { fg = "#ebdbb2", bg = "NONE" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",   { fg = "#fabd2f", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy",{ fg = "#fabd2f", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemKind",        { fg = "#b8bb26", bg = "NONE" })
vim.api.nvim_set_hl(0, "CmpItemMenu",        { fg = "#a89984", bg = "NONE" })
vim.api.nvim_set_hl(0, "CmpItemSel",         { fg = "#282828", bg = "#fabd2f" })
