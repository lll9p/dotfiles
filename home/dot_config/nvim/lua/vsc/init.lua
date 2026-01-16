-- VSCode-Neovim integration entry point
-- This module is loaded when vim.g.vscode is true

local M = {}

M.setup = function()
   require "vsc.settings"
   require "vsc.mappings"
end

return M
