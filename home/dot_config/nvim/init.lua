-- Initialize global variables first
require 'globals'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- Bootstrap lazy.nvim
if not vim.uv.fs_stat(lazypath) then
  local repo = 'https://github.com/folke/lazy.nvim.git'
  vim.notify('Installing lazy.nvim...', vim.log.levels.INFO)
  local out = vim
    .system({
      'git',
      'clone',
      '--filter=blob:none',
      '--branch=stable',
      repo,
      lazypath,
    }, { text = true })
    :wait()

  if out.code ~= 0 then
    vim.notify('Failed to clone lazy.nvim:\n' .. out.stderr, vim.log.levels.ERROR)
  end
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require 'configs.lazy'

-- Load plugins
require('lazy').setup({
  {
    'NvChad/NvChad',
    lazy = false,
    branch = 'v2.5',
    import = 'nvchad.plugins',
  },
  { import = 'plugins' },
}, lazy_config)

-- Load theme
dofile(vim.g.base46_cache .. 'defaults')
dofile(vim.g.base46_cache .. 'statusline')

require 'options'
require 'nvchad.autocmds'

vim.schedule(function()
  require 'mappings'
end)
