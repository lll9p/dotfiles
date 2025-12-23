return {

   {
      "NeogitOrg/neogit",
      dependencies = {
         "nvim-lua/plenary.nvim", -- required
         "sindrets/diffview.nvim", -- optional - Diff integration
         "nvim-telescope/telescope.nvim", -- optional
      },
      opts = { kind = "floating", integrations = { telescope = true, diffview = true }, graph_style = "unicode" },
      cmd = "Neogit",
      cond = not vim.g.vscode,
   },
   {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      config = function(_, opts)
         require("configs.crates")(_, opts)
      end,
      cond = not vim.g.vscode,
   },
}
