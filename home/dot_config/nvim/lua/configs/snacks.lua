local M = {}
M.opts = {
   bigfile = { enabled = true },
   dashboard = {
      enabled = true,
      preset = {
         header = [[
   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
         keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
               icon = " ",
               key = "c",
               desc = "Config",
               action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Sessions", action = ":lua require('persistence').select()" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
         },
      },
      sections = {
         { section = "header", gap = 0, padding = 1 },
         { section = "startup", gap = 0, padding = 1 },
         { section = "keys", gap = 0, padding = 1 },
         { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
         { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      },
   },
   indent = { enabled = true },
   input = { enabled = true },
   notifier = { enabled = true },
   picker = { enabled = true },
   quickfile = { enabled = true },
   scroll = { enabled = true },
   statuscolumn = { enabled = true },
   words = { enabled = true },
}
M.setup = function(_, opts)
   vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#D7BA7D" })
   local notify = vim.notify
   require("snacks").setup(opts)
   -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
   -- this is needed to have early notifications show up in noice history
   vim.notify = notify
end
return M
