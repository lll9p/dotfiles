require "nvchad.options"

local utils = require "utils"
local autocmds = require "autocmds"
utils.set_nvim_options()
utils.set_gui()
utils.enable_providers()
utils.set_python_venv()
utils.set_filetypes()
utils.set_luasnip()
utils.set_visible_chars()
utils.enable_inlay_hints()

autocmds.create_auto_lazy_patch()
autocmds.auto_find_root()
