vim.cmd "packadd packer.nvim"

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
  use 'nvim-treesitter/playground'

  use { 'nvim-telescope/telescope-ui-select.nvim' }
  use {
    "nvim-telescope/telescope.nvim", tag = "0.1.5",
    requires = { { "nvim-lua/plenary.nvim" } }
  }

  use {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    requires = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
    }
  }
  use "stevearc/conform.nvim"

  use "ellisonleao/gruvbox.nvim"
  use "itchyny/lightline.vim"
end)
