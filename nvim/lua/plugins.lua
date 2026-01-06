return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  -- === LOOK & FEEL (jdah-style) ===
  use "morhetz/gruvbox"
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  }

  use "nvim-treesitter/nvim-treesitter"
  use "tpope/vim-surround"
  use "tpope/vim-commentary"
  use "tpope/vim-abolish"
  use "tommcdo/vim-lion"
  use "easymotion/vim-easymotion"
  use "ntpeters/vim-better-whitespace"

  -- === SEARCH ===
  use "junegunn/fzf"
  use "junegunn/fzf.vim"
  use "BurntSushi/ripgrep"

  -- === LSP (MODERN, CLEAN) ===
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"

  -- === COMPLETION (NO PYTHON) ===
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"

  use {
  "windwp/nvim-autopairs",
  config = function()
    require("nvim-autopairs").setup({})
  end,
}

end)

