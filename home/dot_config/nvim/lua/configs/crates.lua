local on_attach = require("nvchad.configs.lspconfig").on_attach
local config = function()
   require("crates").setup {
      lsp = {
         enabled = true,
         on_attach = on_attach,
         actions = true,
         completion = true,
         hover = true,
      },
   }
end

return config
