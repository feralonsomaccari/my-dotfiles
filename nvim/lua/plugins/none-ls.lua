return {
  "nvimtools/none-ls.nvim",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local mason_null_ls = require("mason-null-ls")
    local null_ls = require("null-ls")
    local null_ls_utils = require("null-ls.utils")

    mason_null_ls.setup({
      ensure_installed = {
        "prettier",
        "eslint_d",
      },
    })

    local formatting = null_ls.builtins.formatting
    null_ls.setup({
      root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
      sources = {
        require("none-ls.diagnostics.eslint_d"),
        formatting.prettier,
      },
    })
  end,
}

