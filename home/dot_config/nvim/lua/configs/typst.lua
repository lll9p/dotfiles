vim.api.nvim_create_autocmd({ "FileType" }, {
   pattern = "typst",
   callback = function()
      vim.opt_local.conceallevel = 2
      vim.g.typst_conceal_math = 1
      vim.g.typst_auto_open_quickfix = 1
      if vim.g.__is_windows then
         vim.g.typst_pdf_viewer = "SumatraPDF.exe"
      end
   end,
})
