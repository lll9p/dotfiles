require("nvchad.configs.lspconfig").defaults()
local nvlsp = require "nvchad.configs.lspconfig"
local configs = require "configs.lspopts"

local servers = {
   bashls = {},
   esbonio = {},
   html = {},
   pest_ls = {},
   powershell_es = configs.powershell_es,
   pyright = configs.pyright,
   ruff = {
      on_attach = function(client, bufnr)
         if vim.api.nvim_buf_get_name(bufnr) == "" then
            client.stop()
         end
      end,
   },
   taplo = {},
   tinymist = configs.tinymist,
   ts_ls = configs.ts_ls,
   typos_lsp = configs.typos_lsp,
   yamlls = {},
   nushell = configs.nushell,
   biome = {},
}

-- Use standard Nvim 0.11 config approach
vim.lsp.config("*", {
   capabilities = require("blink.cmp").get_lsp_capabilities(nvlsp.capabilities),
   on_init = nvlsp.on_init,
   on_attach = nvlsp.on_attach,
})

for name, opts in pairs(servers) do
   vim.lsp.config(name, opts)
   vim.lsp.enable(name)
end
