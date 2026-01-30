local M = {}
local unpack = unpack or table.unpack

M.set_nvim_options = function()
   vim.g.loaded_netrw = 1
   vim.g.loaded_netrwPlugin = 1
   vim.diagnostic.config {
      virtual_text = true,
      signs = true,
      update_in_insert = true,
      underline = true,
      severity_sort = false,
      float = true,
   }
   vim.opt.foldenable = true
   vim.opt.foldmethod = "expr"
   vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
   vim.opt.foldtext = ""
   vim.opt.foldlevel = 99
   vim.opt.foldnestmax = 4
   vim.g.codeium_cmp_hide = true
   vim.opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds"

   if vim.g.__is_windows then
      vim.opt.shell = "nu"
      vim.env.SHELL = "nu"
      vim.env.TERM_IN_NEOVIM = "yes"
      vim.opt.shellslash = true -- Forces Neovim to use forward slashes (Critical for Nushell)

      -- NuShell configuration for Neovim
      vim.opt.shelltemp = false
      vim.opt.shellredir = "out+err> %s"
      vim.opt.shellcmdflag = "--stdin --no-newline -c"
      vim.opt.shellxescape = ""
      vim.opt.shellxquote = ""
      vim.opt.shellquote = ""
      vim.opt.shellpipe =
         "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"
   end
end

M.set_luasnip = function()
   local config_path = vim.fn.stdpath "config"
   if type(config_path) == "string" then
      vim.g.vscode_snippets_path = { vim.fs.joinpath(config_path, "snippets") }
   end
end

M.set_gui = function()
   if vim.g.__is_nvim_qt then
      local function gui_opt(opt, val)
         vim.rpcnotify(1, "Gui", opt, val)
      end
      gui_opt("Font", "Sarasa Mono SC Nerd Font:h12")
      gui_opt("Option", "Tabline", 0)
      gui_opt("Option", "Popupmenu", 0)
      gui_opt("Option", "RenderLigatures", 1)
      gui_opt("WindowOpacity", 0.95)
   elseif vim.g.neovide then
      vim.o.guifont = "Sarasa Mono SC Nerd Font,Symbols Nerd Font:h12"
      vim.g.neovide_scale_factor = 1.0
      vim.g.neovide_opacity = 1.0
      vim.g.neovide_remember_window_size = true
      vim.g.neovide_input_ime = true
   end
end

M.set_python_venv = function()
   local venv_dir = vim.env.VIRTUAL_ENVS
   local venv = vim.g.__venv
   if vim.g.__is_windows and venv and venv_dir then
      local venv_path = vim.fs.joinpath(venv_dir, venv, "Scripts")
      vim.g.python3_host_prog = vim.fs.joinpath(venv_path, "python.exe")
      vim.env.PATH = venv_path .. ";" .. vim.env.PATH
      vim.opt.pyxversion = 3
   end
end

M.enable_providers = function()
   local enable_providers = {
      "python3_provider",
      "node_provider",
   }
   for _, plugin in ipairs(enable_providers) do
      vim.g["loaded_" .. plugin] = nil
      vim.cmd.runtime(plugin)
   end
end

M.set_filetypes = function()
   vim.filetype.add {
      extension = {
         scad = "openscad",
         pest = "pest",
         tmpl = function(path, _)
            local part = path:match "%.([^%.]+)%.tmpl$"
            return part or "gotmpl"
         end,
      },
   }
end

M.set_visible_chars = function()
   vim.opt.listchars = { eol = "↵", lead = "‧" }
   vim.opt.list = true
end

M.json_file = function(path)
   local file = io.open(path, "rb")
   if not file then
      return {}
   end
   local content = file:read "*a"
   file:close()
   local ok, data = pcall(vim.json.decode, content)
   return ok and data or {}
end

M.enable_inlay_hints = function()
   vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(event)
         local client = vim.lsp.get_client_by_id(event.data.client_id)
         if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
         end
      end,
   })
end

M.ai_status = function()
   local ok, neocodeium = pcall(require, "neocodeium")
   if not ok then
      return ""
   end

   if not pcall(require, "snacks") then
      return "Snacks not installed"
   end

   local is_dashboard = vim.bo.filetype:find("dash", 1, true) ~= nil
   local symbols = {
      status = {
         [0] = "󰚩 ", -- Enabled
         [1] = "󱚧 ", -- Disabled Globally
         [2] = "󱙻 ", -- Disabled for Buffer
         [3] = "󱙺 ", -- Disabled for Buffer filetype
         [4] = "󱙺 ", -- Disabled for Buffer with enabled function
         [5] = "󱚠 ", -- Disabled for Buffer encoding
      },
      server_status = {
         [0] = "󰣺 ", -- Connected
         [1] = "󰣻 ", -- Connecting
         [2] = "󰣽 ", -- Disconnected
      },
   }

   if is_dashboard then
      return symbols.status[1] .. symbols.server_status[1]
   end

   ---@diagnostic disable-next-line: undefined-field
   local status, server_status = neocodeium.get_status()
   return symbols.status[status] .. symbols.server_status[server_status]
end

---@param path string
---@param cmd string[] git command to execute
---@param error_level number? log level for errors. Hide if nil or false
M.git_execute = function(path, cmd, error_level)
   -- Use vim.system which is much cleaner than vim.fn.system + shell quoting madness
   local final_cmd = { "git", "-C", path, unpack(cmd) }

   local obj = vim.system(final_cmd, { text = true }):wait()

   if obj.code ~= 0 then
      if error_level then
         M.error(final_cmd, obj.stderr or obj.stdout, error_level)
      end
      return { success = false, output = obj.stderr or obj.stdout }
   end

   return { success = true, output = obj.stdout }
end

M.error = function(cmd, msg, level)
   vim.notify(string.format("Error executing: %s\n%s", table.concat(cmd, " "), msg), level or vim.log.levels.ERROR)
end

return M
