local group = vim.api.nvim_create_augroup("CodeCompanionHooks_MCPHub", {})

vim.api.nvim_create_autocmd({ "User" }, {
   pattern = "CodeCompanionChatCreated",
   group = group,
   callback = function(request)
      require "mcphub"
   end,
})
return {
   port = 37373, -- Default port for MCP Hub
   config = vim.fn.expand "~/.config/mcphub/servers.json", -- Absolute path to config file location (will create if not exists)
   native_servers = {}, -- add your native servers here

   auto_approve = true, -- Auto approve mcp tool calls
   -- Extensions configuration
   extensions = {
      avante = {},
      codecompanion = {
         -- Show the mcp tool result in the chat buffer
         -- NOTE:if the result is markdown with headers, content after the headers wont be sent by codecompanion
         show_result_in_chat = true,
         make_vars = true, -- make chat #variables from MCP server resources
         make_slash_commands = true, -- make /slash_commands from MCP server prompts
      },
   },
   --set this to true when using build = "bundled_build.lua"
   use_bundled_binary = false, -- Uses bundled mcp-hub instead of global installation
   shutdown_delay = 0, -- Wait 0ms before shutting down server after last client exits
   -- cmd = cmd,
   -- cmdArgs = args,
   -- Logging configuration
   log = {
      level = vim.log.levels.WARN,
      to_file = false,
      file_path = nil,
      prefix = "MCPHub",
   },
}
