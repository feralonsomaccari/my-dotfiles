return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "html", "cssls", "gopls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local hover = vim.lsp.buf.hover
      vim.lsp.buf.hover = function()
        hover({
          border = "rounded",
        })
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("html", {
        capabilities = capabilities,
      })

      vim.lsp.config("cssls", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("gopls", {
        capabilities = capabilities,
      })

      vim.lsp.enable({
        "ts_ls",
        "html",
        "cssls",
        "lua_ls",
        "gopls",
      })
      vim.diagnostic.config({
        virtual_text = function(_, bufnr)
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          if ok and stats and stats.size > 100 * 1024 then
            return false
          end
          return { spacing = 4, prefix = "●" }
        end,
        signs = true,        -- Show signs (icons) in the gutter
        update_in_insert = false, -- Update diagnostics after leaving insert mode
        underline = true,    -- Underline errors and warnings
        severity_sort = true, -- Sort diagnostics by severity
      })

      vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, {})
      vim.keymap.set("n", "<leader>j", function()
        vim.lsp.buf.definition({
          on_list = function(options)
            if options and options.items and #options.items > 0 then
              local item = options.items[1]
              vim.cmd("edit " .. item.filename)
              vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
            end
          end,
        })
      end, {})
      vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>i", vim.lsp.buf.implementation, {})

      vim.keymap.set("n", "<leader>e", function()
        vim.diagnostic.open_float(nil, { border = "rounded" })
      end, {})
      vim.keymap.set("n", "<leader>h", function()
        vim.lsp.buf.hover()
        -- Close the preview window automatically after selection
        vim.cmd("autocmd CursorMoved,BufHidden <buffer> ++once silent! pclose!")
      end, {})
    end,
  },
}
