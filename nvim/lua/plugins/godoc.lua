return {
  "fredrikaverpil/godoc.nvim",
  version = "*",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = { "go" },
      },
    },
  },
  build = "go install github.com/lotusirous/gostdsym/stdsym@latest",
  cmd = { "GoDoc" },
  opts = {},
  config = function()
    local godoc = require("godoc")

    godoc.setup({
      adapters = {
        {
          name = "go",
          opts = {
            command = "GoDoc",
            get_syntax_info = function()
              return {
                filetype = "godoc",
                language = "go",
              }
            end,
          },
        },
      },
      window = {
        type = "split",
      },
      picker = {
        type = "telescope",
        native = {},
        telescope = {},
        snacks = {},
        mini = {},
        fzf_lua = {},
      },
    })
  end,
}
