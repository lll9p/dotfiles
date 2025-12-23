return {
   -- {
   --    "ravitemer/mcphub.nvim",
   --    dependencies = {
   --       "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
   --    },
   --    -- comment the following line to ensure hub will be ready at the earliest
   --    cmd = "MCPHub", -- lazy load by default
   --    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
   --    opts = require "configs.mcphub",
   --    cond = not vim.g.vscode,
   -- },
   {
      "monkoose/neocodeium",
      event = "InsertEnter",
      config = function()
         require("configs.neocodeium")()
      end,
      cond = not vim.g.vscode,
   },
   {
      "olimorris/codecompanion.nvim",
      event = function()
         if vim.fn.argc() == 0 then
            -- when start with no arguments, means vim will open an dashboard
            -- to fix references.path not fix with first working dir.
            return { "DirChanged", "BufReadPost", "BufNewFile" }
         else
            return { "VeryLazy", "BufReadPost", "BufNewFile" }
         end
      end,
      dependencies = {
         "nvim-lua/plenary.nvim",
         -- "nvim-treesitter/nvim-treesitter",
         -- "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
         { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
         { "echasnovski/mini.diff", opts = {} },
         -- "ravitemer/mcphub.nvim",
         -- {
         --    "Davidyz/VectorCode",
         --    version = "*", -- optional, depending on whether you're on nightly or release
         --    dependencies = { "nvim-lua/plenary.nvim" },
         --    cmd = "VectorCode", -- if you're lazy-loading VectorCode
         -- },
      },
      opts = require "configs.codecompanion",
      cond = not vim.g.vscode,
   },
}
