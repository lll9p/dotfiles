---@type NvPluginSpec[]
return {
   -- File explorer (nvim-tree disabled, using neo-tree)
   { "nvim-tree/nvim-tree.lua", enabled = false },
   {
      "nvim-neo-tree/neo-tree.nvim",
      event = "VeryLazy",
      opts = function()
         return require "configs.neo-tree"
      end,
      cond = not vim.g.vscode,
   },

   -- Flash enhances the built-in search functionality by showing labels
   -- at the end of each match, letting you quickly jump to a specific
   -- location.
   {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {},
   },
   -- which-key helps you remember key bindings by showing a popup
   -- with the active keybindings of the command you started typing.
   {
      "folke/which-key.nvim",
      enabled = true,
      cond = not vim.g.vscode,
   },
   -- git signs highlights text that has changed since the list
   -- git commit, and also lets you interactively stage & unstage
   -- hunks in a commit.

   { "lewis6991/gitsigns.nvim", opts = { debug_mode = false }, cond = not vim.g.vscode },
   -- better diagnostics list and others
   { "folke/trouble.nvim", opts = {}, cmd = "Trouble", cond = not vim.g.vscode },

   { "nvim-telescope/telescope.nvim", opts = function() return require "configs.telescope" end, cond = not vim.g.vscode },
   {
      "folke/persistence.nvim",
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      opts = {},
      keys = {
         { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
         { "<leader>qS", function() require("persistence").select() end, desc = "Select Session" },
         { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
         { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
         {
            "<leader>qD",
            function()
               local dir = vim.fn.stdpath("state") .. "/sessions/"
               local sessions = vim.fn.glob(dir .. "*.vim", false, true)
               if #sessions == 0 then
                  vim.notify("No sessions found", vim.log.levels.WARN)
                  return
               end
               vim.ui.select(sessions, {
                  prompt = "Delete session:",
                  format_item = function(path) return vim.fn.fnamemodify(path, ":t") end,
               }, function(choice)
                  if choice then
                     os.remove(choice)
                     vim.notify("Deleted: " .. vim.fn.fnamemodify(choice, ":t"))
                  end
               end)
            end,
            desc = "Delete Session",
         },
      },
      cond = not vim.g.vscode,
   },
}
