-- VSCode-Neovim plugins
-- These plugins are loaded only when running inside VSCode
return {
   {
      "folke/flash.nvim",
      opts = {},
   },
   { "tpope/vim-repeat" },
   { "tpope/vim-surround" },
   {
      "vscode-neovim/vscode-multi-cursor.nvim",
      cond = not not vim.g.vscode,
      opts = {},
   },
}
