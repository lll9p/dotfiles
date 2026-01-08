require "nvchad.mappings"
local map = vim.keymap.set

map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- neo-tree
map("n", "<C-n>", "<cmd> Neotree float <CR>", { desc = "Neotree file explorer" })
map("n", "<leader>e", "<cmd> Neotree float focus<CR>", { desc = "Neotree focus window" })

-- treesitter
map("n", "<leader>cu", "<cmd> TSCaptureUnderCursor <CR>", { desc = "Find media." })

-- Plugin Trouble
map("n", "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>tX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
map(
   "n",
   "<leader>cl",
   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
   { desc = "LSP Definitions / references / ... (Trouble)" }
)
map("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
map("n", "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

-- inlayhints
map("n", "<leader>i", function()
   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { 0 }, { 0 })
end, { desc = "Toggle inlay hints." })

-- open float diagnostic
map("n", "]d", function()
   vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Jump to the next diagnostic" })

map({ "n", "i" }, "<F1>", vim.lsp.buf.hover, { desc = "LSP signature help" })
map("n", "gh", vim.lsp.buf.hover, { desc = "LSP signature help" })

map("n", "[d", function()
   vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Jump to the previous diagnostic" })
-- stylua: ignore
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
-- stylua: ignore
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
-- stylua: ignore
map("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
-- stylua: ignore
map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
-- stylua: ignore
map({ "c" }, "<C-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

-- map paste
map({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function()
   vim.api.nvim_paste(vim.fn.getreg "+", true, -1)
end, { noremap = true, silent = true, desc = "Paste from clipboard." })

map("n", "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "CodeCompanionChat Toggle" })

-- nomap("n", "<leader>/")
-- nomap("v", "<leader>/")
