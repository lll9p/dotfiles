-- Development plugins: LSP, Treesitter, Formatting, Debug
return {
   -- Treesitter
   {
      "nvim-treesitter/nvim-treesitter",
      event = { "BufReadPost", "BufNewFile", "FileType" },
      lazy = true,
      build = ":TSUpdate",
      opts = function()
         return require "configs.treesitter"
      end,
      config = function(_, opts)
         if vim.g.__is_windows then
            require("nvim-treesitter.install").compilers = { "clang" }
         end
         require("nvim-treesitter.configs").setup(opts)
      end,
      cond = not vim.g.vscode,
   },

   -- Formatting
   {
      "stevearc/conform.nvim",
      event = { "BufWritePre", "FileType" },
      opts = require "configs.conform", ---@diagnostic disable-line: different-requires
      cond = not vim.g.vscode,
   },

   -- LSP
   {
      "neovim/nvim-lspconfig",
      opts = {
         inlay_hints = { enabled = true },
      },
      dependencies = {},
      config = function()
         ---@diagnostic disable-next-line: different-requires
         require "configs.lspconfig"
      end,
      event = { "User FilePost", "InsertEnter", "FileType" },
      cond = not vim.g.vscode,
   },

   {
      "mason-org/mason.nvim",
      opts = {
         github = {
            download_url_template = vim.g.__github_mirror_mason .. "https://github.com/%s/releases/download/%s/%s",
         },
      },
      event = { "User FilePost", "FileType" },
      cond = not vim.g.vscode,
   },

   -- Typst support
   {
      "kaarmu/typst.vim",
      ft = "typst",
      lazy = false,
      config = function()
         require "configs.typst"
      end,
      cond = not vim.g.vscode,
   },

   -- Debug (disabled)
   {
      "rcarriga/nvim-dap-ui",
      enabled = false,
      dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
      cond = not vim.g.vscode,
   },
}
