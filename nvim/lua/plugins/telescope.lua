local function focus_preview(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_win = picker.prompt_win
  local previewer = picker.previewer
  local bufnr = previewer.state.bufnr or previewer.state.termopen_bufnr
  local winid = previewer.state.winid or vim.fn.win_findbuf(bufnr)[1]
  vim.keymap.set("n", "<C-i>", function()
    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
  end, { buffer = bufnr })
vim.keymap.set("n", "<D-i>", function()
    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
  end, { buffer = bufnr })

  vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
  -- api.nvim_set_current_win(winid)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>p", builtin.find_files, {})
      vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>b", builtin.buffers, {})
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            n = {
              ["<C-i>"] = focus_preview,
              ["<D-i>"] = focus_preview,
            },
          },
          file_ignore_patterns = { ".git/", "node_modules/", "%.o", "%.a", "%.out",
            "%.pdf", "%.mkv", "%.mp4", "%.zip", ".cache", "dist", "coverage", "es5", "%.snap" }
        },
        preview = {
          filesize_limit = 0.5555,
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          buffers = {
            initial_mode = "normal",
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      require("telescope").load_extension("ui-select")
    end,
  },
  {
    "nvim-telescope/telescope-fzy-native.nvim",
    run = "make",
    config = function()
      require("telescope").setup({
        extensions = {
          fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
          },
        },
      })
      require("telescope").load_extension("fzy_native")
    end,
  },
}
