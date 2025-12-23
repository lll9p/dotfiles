return {

   {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = require("configs.snacks").opts,
      config = require("configs.snacks").setup,
      cond = not vim.g.vscode,
   },
   {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {},
      config = require "configs.noice",
      dependencies = {
         -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
         -- "MunifTanjim/nui.nvim",
         -- OPTIONAL:
         --   `nvim-notify` is only needed, if you want to use the notification view.
         --   If not available, we use `mini` as the fallback
         "rcarriga/nvim-notify",
      },
      cond = not vim.g.vscode,
   },
   {
      "MunifTanjim/nui.nvim",
      cond = not vim.g.vscode,
   },
   { "lukas-reineke/indent-blankline.nvim", opts = require "configs.blankline", cond = not vim.g.vscode },

   -- nvim-cmp disabled, using blink.cmp instead
   { "hrsh7th/nvim-cmp", enabled = false },
   {
      "saghen/blink.cmp",
      version = "1.*",
      event = { "InsertEnter", "CmdLineEnter" },
      dependencies = {
         "rafamadriz/friendly-snippets",
         {
            -- snippet plugin
            "L3MON4D3/LuaSnip",
            dependencies = "rafamadriz/friendly-snippets",
            opts = { history = true, updateevents = "TextChanged,TextChangedI" },
            config = function(_, opts)
               require("luasnip").config.set_config(opts)
               require "nvchad.configs.luasnip"
            end,
         },
      },
      opts = require "configs.blink",
      opts_extend = { "sources.default" },
      cond = not vim.g.vscode,
   },
   {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {
         fast_wrap = {},
         disable_filetype = { "TelescopePrompt", "vim" },
      },
      config = function(_, opts)
         require("nvim-autopairs").setup(opts)
         -- setup cmp for autopairs
         -- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
         -- require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
      cond = not vim.g.vscode,
   },
}
