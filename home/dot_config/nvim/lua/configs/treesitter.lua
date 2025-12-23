local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.openscad = {
   install_info = {
      url = "https://github.com/bollian/tree-sitter-openscad.git", -- local path or git repo
      files = { "src/parser.c" },
      branch = "master",
      generate_requires_npm = false,
      requires_generate_from_grammar = true,
   },
   filetype = "openscad",
}

return {
   ensure_installed = {
      "bash",
      "c",
      "css",
      "gotmpl",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "markdown",
      "nu",
      "printf",
      "python",
      "query",
      "regex",
      "rst",
      "rust",
      "toml",
      "vim",
      "vimdoc",
      "yaml",
   },
   highlight = {
      enable = true,
   },
   indent = { enable = true },
}
