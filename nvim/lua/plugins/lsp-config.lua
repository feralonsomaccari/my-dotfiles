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
        ensure_installed = { "lua_ls", "vtsls", "html", "cssls", "gopls", "eslint" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- The eslint LSP nags loudly when a repo's own eslint config fails to
      -- load (e.g. eslint.config.js require()s a package missing from that
      -- repo's node_modules, or .eslintrc.js extends a config that isn't
      -- installed). With cmdheight=0 this triggers a "Press ENTER" prompt.
      -- The repo is broken, not the editor — drop those messages.
      local eslint_noise = {
        "Require stack",
        "Failed to load config", -- extends a missing shareable config
        "Cannot find module",
      }
      local orig_notify = vim.notify
      vim.notify = function(msg, level, opts)
        if type(msg) == "string" then
          for _, pat in ipairs(eslint_noise) do
            if msg:find(pat, 1, true) then
              return
            end
          end
        end
        return orig_notify(msg, level, opts)
      end

      local hover = vim.lsp.buf.hover
      vim.lsp.buf.hover = function()
        hover({
          border = "rounded",
        })
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("vtsls", {
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

      -- Only attach the eslint server in repos that ship their own eslint
      -- config. This stops it from walking up the tree and erroring on a
      -- stray .eslintrc.js (e.g. extends "standard") in some parent dir.
      vim.lsp.config("eslint", {
        capabilities = capabilities,
        root_dir = function(bufnr, on_dir)
          local cfg = vim.fs.find({
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            "eslint.config.ts",
          }, {
            upward = true,
            stop = vim.env.HOME,
            path = vim.api.nvim_buf_get_name(bufnr),
          })[1]
          if cfg then
            on_dir(vim.fs.dirname(cfg))
          end
        end,
      })

      vim.lsp.enable({
        "vtsls",
        "html",
        "cssls",
        "lua_ls",
        "gopls",
        "eslint",
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
