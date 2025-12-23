local git_execute = require("utils").git_execute
-- local global = require "global"
local path_sep = vim.g.__path_sep

local lazy_path = vim.fn.stdpath "data" .. path_sep .. "lazy"
local patches_path = vim.fn.stdpath "config" .. path_sep .. "patches" -- directory where diff patches files are stored
local M = {}

local NOTIFIER = "[lazy-local-patcher] "

---@param name string Name of the plugin repository
---@param repo_path string Full path of the plugin repository
local function restore_repo(name, repo_path)
   local result = git_execute(repo_path, { "restore", "." })
   if not result.success then
      local msg = string.format(": Error restoring the repository. Check '%s'", repo_path)
      vim.notify(NOTIFIER .. name .. msg, vim.log.levels.ERROR)
   end
   vim.notify(NOTIFIER .. "Restored " .. name, vim.log.levels.TRACE)
end

---@param name string Name of the plugin repository
---@param patch_path string Full path of the patch file
---@param repo_path string Full path of the plugin repository
local function apply_patch(name, patch_path, repo_path)
   local result = git_execute(repo_path, { "apply", "--ignore-space-change", patch_path })
   if not result.success then
      local msg = string.format(": Error applying patches to the repository. Check '%s'", repo_path)
      vim.notify(NOTIFIER .. name .. msg, vim.log.levels.ERROR)
   end
   vim.notify(NOTIFIER .. "Applied " .. name, vim.log.levels.TRACE)
end

local function apply_all()
   for patch in vim.fs.dir(patches_path) do
      if patch:match "%.patch$" ~= nil then
         local patch_path = patches_path .. path_sep .. patch
         local repo_path = lazy_path .. path_sep .. patch:gsub("%.patch", "")
         apply_patch(patch, patch_path, repo_path)
      end
   end
end

local function restore_all()
   for patch in vim.fs.dir(patches_path) do
      if patch:match "%.patch$" ~= nil then
         local repo_path = lazy_path .. path_sep .. patch:gsub("%.patch", "")
         restore_repo(patch, repo_path)
      end
   end
end

M.create_auto_lazy_patch = function()
   local group_id = vim.api.nvim_create_augroup("LazyPatches", {})
   M.sync_call = false

   vim.api.nvim_create_autocmd("User", {
      desc = "Restore patches when Lazy 'Pre' events are triggered.",
      group = group_id,
      pattern = { "LazySyncPre", "LazyInstallPre", "LazyUpdatePre", "LazyCheckPre" },
      callback = function(ev)
         if not M.sync_call then
            restore_all()
         end
         if ev.match == "LazySyncPre" then
            M.sync_call = true
         end
      end,
   })

   vim.api.nvim_create_autocmd("User", {
      desc = "Apply patches when Lazy events are triggered.",
      group = group_id,
      pattern = { "LazySync", "LazyInstall", "LazyUpdate", "LazyCheck" },
      callback = function(ev)
         if not M.sync_call then
            apply_all()
         elseif ev.match == "LazySync" then
            apply_all()
            M.sync_call = false
         end
      end,
   })
end
-- Show Nvdash when all buffers are closed
-- Show Nvdash when all buffers are closed
-- vim.api.nvim_create_autocmd("BufDelete", {
--    callback = function()
--       local bufs = vim.t.bufs
--       if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
--          vim.cmd "Nvdash"
--       end
--    end,
-- })

local autocmd = vim.api.nvim_create_autocmd
local ui_helpers = vim.api.nvim_create_augroup("UiHelpers", { clear = true })

-- disable buggy anims in completion windows
autocmd("User", {
   group = ui_helpers,
   pattern = "BlinkCmpMenuOpen",
   callback = function()
      vim.g.snacks_animate = false
   end,
})

autocmd("User", {
   group = ui_helpers,
   pattern = "BlinkCmpMenuClose",
   callback = function()
      vim.g.snacks_animate = true
   end,
})

return M
