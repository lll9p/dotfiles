-- todo: experimental nvchad blink support
local nvchad_blink = require "nvchad.blink"
local nvchad_blink_config = require "nvchad.blink.config"
---@module 'blink.cmp'
---@type blink.cmp.Config
local opts = {
   -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
   -- 'super-tab' for mappings similar to vscode (tab to accept)
   -- 'enter' for enter to accept
   -- 'none' for no mappings
   --
   -- All presets have the following mappings:
   -- C-space: Open menu or open docs if already open
   -- C-n/C-p or Up/Down: Select next/previous item
   -- C-e: Hide menu
   -- C-k: Toggle signature help (if signature.enabled = true)
   --
   -- See :h blink-cmp-config-keymap for defining your own keymap
   -- https://github.com/Saghen/blink.cmp/blob/main/docs/configuration/keymap.md
   snippets = { preset = "luasnip" },
   keymap = {
      preset = "enter",
      ["<C-q>"] = { "show", "fallback" },
      ["<Tab>"] = {
         function(cmp)
            if cmp.is_visible() then
               return cmp.select_next()
            elseif cmp.snippet_active() then
               return cmp.snippet_forward()
            else
               return false
            end
         end,
         "fallback",
      },
      ["<S-Tab>"] = {
         function(cmp)
            if cmp.is_visible() then
               return cmp.select_prev()
            elseif cmp.snippet_active() then
               return cmp.snippet_backward()
            else
               return false
            end
         end,
         "fallback",
      },
   },
   signature = {
      enabled = true,
      -- window = { border = "single" },
   },

   appearance = {
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",
   },
   completion = {
      accept = {
         -- experimental auto-brackets support
         auto_brackets = {
            enabled = true,
         },
      },
      menu = {
         scrollbar = nvchad_blink.menu.scrollbar,
         border = nvchad_blink.menu.border,
         draw = {
            columns = nvchad_blink.menu.draw.columns,
            components = nvchad_blink.components,
            treesitter = { "lsp" },
         },
         -- don't show completion when searching
         auto_show = function(ctx)
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
         end,
      },
      documentation = {
         auto_show = true,
         auto_show_delay_ms = 200,
         window = nvchad_blink_config.completion.documentation.window,
      },
      ghost_text = {
         enabled = true,
      },
      list = {
         selection = {
            preselect = function(ctx)
               return ctx.mode ~= "cmdline"
            end,
            auto_insert = function(ctx)
               return ctx.mode == "cmdline"
            end,
         },
      },
   },
   -- Default list of enabled providers defined so that you can extend it
   -- elsewhere in your config, without redefining it, due to `opts_extend`
   sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer", "codecompanion" },
      providers = {
         lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
         },
         codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
         },
         snippets = {
            should_show_items = function(ctx)
               return ctx.trigger.initial_kind ~= "trigger_character"
            end,
         },
      },
   },
   cmdline = {
      enabled = true,
      -- sources = { "cmdline" },
      -- preset = "enter",
      completion = { menu = { auto_show = false } },
      keymap = {
         preset = "cmdline",
         ["<Tab>"] = {
            "show_and_insert",
            "select_next",
            "fallback",
         },
         ["<S-Tab>"] = { "select_prev", "fallback" },
      },
   },
   -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
   -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
   -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
   --
   -- See the fuzzy documentation for more information
   fuzzy = { implementation = "prefer_rust_with_warning" },
}
return opts
