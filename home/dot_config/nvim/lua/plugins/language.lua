return {

   {
      "microsoft/python-type-stubs",
      cond = not vim.g.vscode,
   },

   {
      "linux-cultist/venv-selector.nvim",
      dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" }, --, "mfussenegger/nvim-dap-python" },
      -- event = "VeryLazy",
      opts = require "configs.venv-selector",
      cond = not vim.g.vscode,
   },
   { "mrcjkb/rustaceanvim", config = require "configs.rustaceanvim", lazy = false, cond = not vim.g.vscode },
   {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
         library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
         },
      },
      cond = not vim.g.vscode,
   },
}
