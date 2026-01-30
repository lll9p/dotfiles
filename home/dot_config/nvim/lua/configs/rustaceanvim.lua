local func = function(_, _)
   vim.g.rustaceanvim = {
      server = {
         on_attach = function(client, bufnr)
            require("nvchad.configs.lspconfig").on_attach(client, bufnr)
         end,
         cmd = function()
            local mason_registry = require "mason-registry"
            if mason_registry.is_installed "rust-analyzer" then
               -- This may need to be tweaked depending on the operating system.
               local ra = mason_registry.get_package "rust-analyzer"
               local ra_filename = ra:get_receipt():get().links.bin["rust-analyzer"]
               return {
                  vim.fs.joinpath(vim.fn.expand "$MASON", "packages", "rust-analyzer", ra_filename or "rust-analyzer"),
               }
            -- return { ("%s/%s"):format(ra:get_install_path(), ra_filename or "rust-analyzer") }
            else
               -- global installation
               return { "rust-analyzer" }
            end
         end,
         default_settings = {
            ["rust-analyzer"] = {
               rustfmt = {
                  extraArgs = { "+nightly" },
               },
               check = {
                  command = "check",
                  --    extraArgs = { "--no-deps" },
               },
               checkOnSave = true,
               files = {
                  watcher = "client",
               },

               procMacro = {
                  ignored = {},
                  attributes = {
                     enable = true,
                  },
                  enable = true,
               },
            },
         },
      },
   }
end
return func
