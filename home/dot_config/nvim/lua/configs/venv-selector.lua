local ext = ""
if vim.g.__is_windows then
   ext = ".exe"
   return {
      search = {
         venvs = {
            command = "fd python" .. ext .. "$ " .. vim.env["VIRTUAL_ENVS"],
         },
      },
   }
else
   return {}
end
