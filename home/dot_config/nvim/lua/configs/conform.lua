local util = require "conform.util"
local options = {
   formatters = {
      typstfmt = {
         command = "typstfmt",
      },
      rustfmt_nightly = {
         stdin = true,
         command = "rustfmt",
         args = "+nightly",
         cwd = util.root_file {
            "Cargo.toml",
         },
      },
   },
   formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format", "ruff_fix" },
      -- python = function(bufnr)
      --    if require("conform").get_formatter_info("ruff_format", bufnr).available then
      --       return { "ruff_format" }
      --    else
      --       return { "isort", "black" }
      --    end
      -- end,
      sh = { "shfmt" },
      json = { "prettier" },
      typst = { "typstfmt" },
      rust = { "rustfmt_nightly", "rustfmt", lsp_format = "first", stop_after_first = true },
      toml = { lsp_format = "first" },
      -- nu = { "nufmt", lsp_format = "fallback" },
      -- Use the "*" filetype to run formatters on all filetypes.
      -- ["*"] = { "codespell" },
      -- Use the "_" filetype to run formatters on filetypes that don't
      -- have other formatters configured.
      ["_"] = { "trim_whitespace" },
   },
   format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
   },
}
return options
