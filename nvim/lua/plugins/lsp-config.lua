return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "html", "cssls", "clangd" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
      })
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.clangd.setup({
        capabilities = capabilities,
      })

      --[[  -- Disable diagnostics virtual text (the "W", "E" icons)
      vim.diagnostic.config({
        virtual_text = false, -- Disables virtual text icons
        signs = false,        -- Disables the gutter signs (W, E, etc.)
        update_in_insert = true,
        underline = true,
        severity_sort = true,
      })


 ]]

      local hover = vim.lsp.buf.hover
      vim.lsp.buf.hover = function()
        hover({
          border = 'rounded',
        })
      end
      vim.keymap.set("n", "<leader>h", function()
        -- Trigger hover
        vim.lsp.buf.hover()
        -- Close the preview window automatically after selection
        vim.cmd("autocmd CursorMoved,BufHidden <buffer> ++once silent! pclose!")
      end, {})

      vim.keymap.set("n", "<leader>j", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>.", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, {});
    end,
  },
}
