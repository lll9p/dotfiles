local map = vim.keymap.set

local config = function()
   local ai = require "neocodeium"
   -- local blink = require "blink.cmp" -- Removed eager load
   vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuOpen",
      callback = function()
         ai.clear()
      end,
   })
   ai.setup {
      silent = true,
      manual = true,
      filetypes = {
         nvdash = false,
         snacks_dashboard = false,
         TelescopePrompt = false,
         ["dap-repl"] = false,
      },
      filter = function()
         -- Only check blink if it is already loaded to avoid forcing it
         if package.loaded["blink.cmp"] then
            return not require("blink.cmp").is_visible()
         end
         return true
      end,
   }
   map("i", "<A-q>", ai.accept, { desc = "AI accept" })
   map("i", "<A-w>", ai.accept_word, { desc = "AI accept word" })
   map("i", "<A-a>", ai.accept_line, { desc = "AI accept line" })
   map("i", "<M-]>", ai.cycle_or_complete, { desc = "AI cycle" })
   map("i", "<M-[>", function()
      ai.cycle_or_complete(-1)
   end, { desc = "AI cycle" })
   map("i", "<M-c>", ai.clear, { desc = "AI clear" })
end
return config
