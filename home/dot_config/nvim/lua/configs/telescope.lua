local nvtelescope = require "nvchad.configs.telescope"
nvtelescope.extensions.media_files = {
   -- fd is needed
   media_files = {
      filetypes = { "png", "webp", "jpg", "jpeg" },
   },
}
nvtelescope.defaults.mappings = {
   n = { ["q"] = require("telescope.actions").close },
   i = {
      -- map actions.which_key to <C-h> (default: <C-/>)
      -- actions.which_key shows the mappings for your picker,
      -- e.g. git_{create, delete, ...}_branch for the git_branches picker
      ["<C-h>"] = "which_key",
   },
}
return nvtelescope
