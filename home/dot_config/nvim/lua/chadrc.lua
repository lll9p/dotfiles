---@type ChadrcConfig
local M = {}
M.base46 = {
   theme = "one_light", --default theme
   theme_toggle = { "one_light", "github_dark", "catppuccin" },
}

if not vim.g.vscode then
   M.lsp = { signature = false }
   M.mason = {
      pkgs = {
         -- lua stuff
         "lua-language-server",
         "stylua",
         -- web dev
         "css-lsp",
         "html-lsp",
         "typescript-language-server",
         -- "deno",
         -- "emmet-ls",
         -- "json-lsp",
         "yaml-language-server",
         -- rust
         "rust-analyzer",
         -- python
         "pyright",
         "ruff",
         -- shell
         "shfmt",
         "shellcheck",
         "bash-language-server",

         -- openscad
         "openscad-lsp",
         "isort",
         "black",
         "codespell",
         "esbonio",
         "eslint-lsp",
         "xmlformatter",
         "tinymist",
      },
   }
   M.ui = {
      -- cmp = {
      --    icons = true,
      --    lspkind_text = true,
      --    format_colors = {
      --       tailwind = true,
      --       icon = "󱓻",
      --    },
      --    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
      --    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
      --    selected_item_bg = "colored", -- colored / simple
      -- },

      telescope = { style = "bordered" },
      statusline = {
         order = {
            "mode",
            "file",
            "git",
            "%=",
            "lsp_msg",
            "%=",
            "diagnostics",
            "lsp",
            -- "ai_status",
            "cursor",
            "cwd",
         },
         modules = {
            -- ai_status = require("utils").ai_status,
         },
      },
   }
   M.nvdash = {
      load_on_startup = false,
      header = {
         "                            ",
         "     ▄▄         ▄ ▄▄▄▄▄▄▄   ",
         "   ▄▀███▄     ▄██ █████▀    ",
         "   ██▄▀███▄   ███           ",
         "   ███  ▀███▄ ███           ",
         "   ███    ▀██ ███           ",
         "   ███      ▀ ███           ",
         "   ▀██ █████▄▀█▀▄██████▄    ",
         "     ▀ ▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀   ",
         "                            ",
         "     Powered By  eovim    ",
         "                            ",
      },

      buttons = {
         { txt = "  New File", keys = "nf", cmd = ":ene | startinsert" },
         { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
         { txt = "  Recent Files", keys = "to", cmd = "Telescope oldfiles" },
         { txt = "  Sessions", hl = "Function", keys = "ss", cmd = ":lua require('persistence').select()" },
         { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
         { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
         { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
         { txt = "󰒲  Lazy", keys = "L", cmd = ":Lazy" },
         { txt = "  Quit", keys = "q", cmd = ":qa" },
         { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

         {
            txt = function()
               local stats = require("lazy").stats()
               local ms = math.floor(stats.startuptime) .. " ms"
               return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
            end,
            hl = "NvDashFooter",
            no_gap = true,
         },

         { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
      },
   }
else
   M.ui = { statusline = { order = {} } }
end
return M
