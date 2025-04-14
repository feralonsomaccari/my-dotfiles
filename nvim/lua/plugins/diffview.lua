return {
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      local actions = require("diffview.actions")

      require("diffview").setup({
        enhanced_diff_hl = true,
        keymaps = {
          view = {
            { "n", "<Tab>",   actions.select_next_entry, { desc = "Open next file" } },
            { "n", "<S-Tab>", actions.select_prev_entry, { desc = "Open previous file" } },
          },
          file_panel = {
            { "n", "<Tab>",   actions.select_next_entry, { desc = "Next entry" } },
            { "n", "<S-Tab>", actions.select_prev_entry, { desc = "Previous entry" } },
          },
        },
      })

      -- Keybinding to open Diffview
      vim.api.nvim_set_keymap('n', '<leader>go', '<cmd>DiffviewOpen<CR>', { noremap = true, silent = true })

      -- Keybinding to close Diffview
      vim.api.nvim_set_keymap('n', '<leader>gq', '<cmd>DiffviewClose<CR>', { noremap = true, silent = true })

      -- Tab and Shift-Tab mappings to navigate buffers
      vim.api.nvim_set_keymap('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })
    end,
  },
}
