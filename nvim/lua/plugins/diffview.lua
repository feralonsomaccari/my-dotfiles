return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    local diffview = require("diffview")
    local actions = require("diffview.actions")

    diffview.setup({
      view = {
        default = { 
          winbar_info = false,
          disable_diagnostics = true,
        },
        merge_tool = {
          -- layout = "diff1_plain",
          disable_diagnostics = true,
          winbar_info = false,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "list",
        win_config = { winbar = nil, tabline = nil },
      },
      keymaps = {
        view = {
          { "n", "gf", function() actions.goto_file_edit(); vim.cmd("tabclose #") end,
            { desc = "Open file, then close Diffview tab" } },
        },
        file_panel = {
          { "n", "gf", function() actions.goto_file_edit(); vim.cmd("tabclose #") end,
            { desc = "Open file, then close Diffview tab" } },
        },
        file_history_panel = {
          { "n", "gf", function() actions.goto_file_edit(); vim.cmd("tabclose #") end,
            { desc = "Open file, then close Diffview tab" } },
        },
      },
    })

    vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory %<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>dr", "<cmd>DiffviewFileHistory<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<C-w>[", "<C-w>h", { noremap = true, silent = true })
    vim.keymap.set("n", "<C-w>]", "<C-w>l", { noremap = true, silent = true })
  end,
}


