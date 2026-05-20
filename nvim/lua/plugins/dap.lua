return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      { "jay-babu/mason-nvim-dap.nvim", dependencies = { "williamboman/mason.nvim" } },
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<leader>bb", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      { "<leader>bB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Debug: conditional breakpoint" },
      { "<leader>bc", function() require("dap").continue() end, desc = "Debug: continue / start" },
      { "<leader>bi", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<leader>bo", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<leader>bO", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>br", function() require("dap").repl.toggle() end, desc = "Debug: toggle REPL" },
      { "<leader>bl", function() require("dap").run_last() end, desc = "Debug: run last" },
      { "<leader>bx", function() require("dap").terminate() end, desc = "Debug: terminate" },
      { "<leader>bu", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
      { "<leader>be", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Debug: eval expression" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason-nvim-dap").setup({
        ensure_installed = { "js-debug-adapter", "delve" },
        automatic_installation = true,
        handlers = {},
      })

      dapui.setup()
      require("nvim-dap-virtual-text").setup({})

      -- Open/close UI automatically with debug sessions.
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- Sign column markers.
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

      -- Go: nvim-dap-go wires up delve with sensible defaults (incl. test debugging).
      require("dap-go").setup()

      -- JavaScript / TypeScript / Node: js-debug-adapter via Mason.
      -- Use $MASON (set by mason.nvim) to avoid the removed get_install_path() API.
      local js_debug = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter"
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { js_debug .. "/js-debug/src/dapDebugServer.js", "${port}" },
        },
      }
      for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[ft] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file (node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to running node (port 9229)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
