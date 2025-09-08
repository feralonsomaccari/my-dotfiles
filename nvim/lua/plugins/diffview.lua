return {
  "sindrets/diffview.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    local diffview = require("diffview")
    local actions = require("diffview.actions")

    diffview.setup({
      view = {
        default = { winbar_info = false },
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
      hooks = {
        view_opened = function(view)
      vim.schedule(function()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(view.tabpage)) do
        vim.api.nvim_win_call(win, function()
          vim.cmd("normal! zR")
        end)
      end
    end)
          if view.left_file then
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local name = vim.api.nvim_buf_get_name(buf)
              if name:match(view.left_file) then
                vim.bo[buf].modifiable = false
                vim.bo[buf].readonly = true
              end
            end
          end
        end,
      },
    })

    vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<C-w>[", "<C-w>h", { noremap = true, silent = true })
    vim.keymap.set("n", "<C-w>]", "<C-w>l", { noremap = true, silent = true })
  end,
}

