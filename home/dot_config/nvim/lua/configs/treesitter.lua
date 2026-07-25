local M = {}

M.languages = {
   "bash",
   "c",
   "css",
   "gotmpl",
   "html",
   "javascript",
   "json",
   "lua",
   "luadoc",
   "markdown",
   "nu",
   "printf",
   "python",
   "query",
   "regex",
   "rst",
   "rust",
   "toml",
   "vim",
   "vimdoc",
   "yaml",
}

function M.setup()
   local treesitter = require "nvim-treesitter"
   treesitter.setup {}
   treesitter.install(M.languages)

   vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true }),
      pattern = M.languages,
      callback = function(args)
         if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
         end
      end,
   })
end

return M
