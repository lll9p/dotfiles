return {
   log_level = "error",
   log_to_file = false,
   -- enable_git_status = false,
   popup_border_style = "rounded",
   filesystem = {
      use_libuv_file_watcher = false, -- if set true, will make nvim consume too much memory
      use_fscache = true,
      filtered_items = {
         visible = false,
         hide_dotfiles = true,
         hide_gitignored = true, -- 如果是 Git 项目，这会极大减轻压力
         hide_by_name = {
            "node_modules",
            "target",
            "build",
            "dist",
            ".git",
         },
         never_show = { -- 这些文件夹绝对不扫描
            ".DS_Store",
            "thumbs.db",
         },
      },
      follow_current_file = {
         enabled = true,
         leave_dirs_open = true,
      },
   },
}
