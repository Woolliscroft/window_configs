-- NOTE: This configuration is meant for Neovim v0.11 or greater

-- Learn about Neovim's lua api
-- https://neovim.io/doc/user/lua-guide.html

-- install packers

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- if not already installed
  use 'windwp/nvim-autopairs'
  -- add other plugins here
end)

vim.o.number = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.wrap = false
vim.o.hlsearch = false
vim.o.signcolumn = 'yes'

-- Space as the leader key
vim.g.mapleader = vim.keycode('<Space>')

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard text'})

-- Command shortcuts
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save file'})
vim.keymap.set('n', '<leader>q', '<cmd>quitall<cr>', {desc = 'Exit vim'})

vim.cmd.colorscheme('retrobox')

-- Load packer.nvim
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer manages itself
  use 'windwp/nvim-autopairs'  -- Auto pairs plugin
  -- add other plugins here
end)


require('nvim-autopairs').setup({})
vim.o.cindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.smartindent = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "java" },
  callback = function()
    vim.bo.cindent = true
    vim.bo.smartindent = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})


require('mini.snippets').setup({})
require('mini.completion').setup({})

require('mini.files').setup({})
vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<cr>', {desc = 'File explorer'})

require('mini.pick').setup({})
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<cr>', {desc = 'Search help tags'})

-- List of compatible language servers is here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local lspconfig = require('lspconfig')

local servers = { 'gopls', 'rust_analyzer', 'clangd', 'ccls', 'pylsp', 'jdtls' }

for _, server in ipairs(servers) do
  lspconfig[server].setup{}
end
