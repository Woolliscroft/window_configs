vim.g.mapleader = ","

require("plugins")
require("mylsp")
require("nvimcmp")

vim.cmd([[ so ~/.config/nvim/legacy.vim ]])

