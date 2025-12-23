local map = vim.keymap.set

-- General mappings, must keep for vscode compatibility
map("n", ";", ":", {
   nowait = true,
   desc = "enter command mode",
})

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- blackhole mappings
map("n", "<C-c>", "_", {
   desc = "Blackhole",
})
if vim.g.vscode then
   require "vscode.mappings"
else
   require "mappings.mappings"
end
