local M = {}

M.powershell_es = {
   filetypes = { "ps1" },
   bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
}

M.pyright = {
   settings = {
      filetypes = { "python" },
      pyright = {
         disableOrganizeImports = true, -- Using Ruff's import organizer
         -- openFilesOnly = true,
      },
      python = {
         analysis = {
            -- Ignore all files for analysis to exclusively use ruff for linting
            -- ignore = { "*" },
            stubPath = vim.fn.stdpath "data" .. "/lazy/python-type-stubs",
         },
      },
   },
}


M.ts_ls = {
   settings = {
      javascript = {
         inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = false,
         },
      },

      typescript = {
         inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = false,
         },
      },
   },
}

M.tinymist = {
   settings = {
      exportPdf = "onType", -- Choose onType, onSave or never.
      outputPath = "$root/target/$dir/$name",
   },

   root_dir = function()
      return vim.fn.getcwd()
   end,
}
M.nushell = {
   cmd = { "nu", "--lsp" },
   pattern = { "*.nu" },
}
M.typos_lsp = {
   filetypes = { "*" },
   single_file_support = true,
   root_dir = function()
      return vim.uv.cwd()
   end,
   init_options = {
      diagnosticSeverity = "Warning",
   },
}
return M
